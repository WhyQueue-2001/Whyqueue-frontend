import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:whyqueue/widgets/queueReservationtile.dart';

class RestaurantDashboard extends StatefulWidget {
  Map<String, dynamic>? hotelData; // Receiving hotel data via constructor

  RestaurantDashboard({Key? key, this.hotelData}) : super(key: key);

  @override
  _RestaurantDashboardState createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> reservations = [];
  List<Map<String, dynamic>> queueReservations = [];
  Map<String, TextEditingController> timeControllers = {};
  Map<String, int?> selectedTables =
      {}; // Tracks selected table per reservation
  int? selectedAddTable; // For the add user dialog
  String get hotelName => widget.hotelData?['restaurantName'] ?? 'Unknown';
  List<dynamic> tableList = [];
  StreamSubscription<DatabaseEvent>? _reservationSubscription;
  StreamSubscription<DatabaseEvent>? _reservationSubscriptionNonQueue;
  @override
  void initState() {
    super.initState();
    print("Inside initstate");
    _fetchReservations();

    _fetchQueueReservations();
    tableList = widget.hotelData?['tableSizes'] ?? [];
    print("Loaded tables: $tableList"); // for debugging
  }

  // 🔹 Fetch reservations filtered by hotel name (non-queue)
  void _fetchReservations() {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");
    _reservationSubscriptionNonQueue = dbRef.onValue.listen((event) {
      if (!mounted) return;
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> tempList = [];

        data.forEach((key, value) {
          if (value["restaurantName"] == hotelName &&
              value["status"] != "Queue") {
            tempList.add({"id": key, ...value});
            timeControllers[key] = TextEditingController();
          }
        });

        setState(() {
          reservations = tempList;
        });
      }
    });
  }

  void _fetchQueueReservations() {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");

    _reservationSubscription = dbRef.onValue.listen((event) {
      if (!mounted) return; // Prevent calling setState after dispose

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> tempList = [];

        data.forEach((key, value) {
          if (value["restaurantName"] == hotelName &&
              value["status"] == "Queue") {
            final reservation = Map<String, dynamic>.from(value);
            reservation["id"] = key.toString(); // Add ID from Firebase
            tempList.add(reservation);
          }
        });

        tempList.sort((a, b) => a["id"].compareTo(b["id"]));

        setState(() {
          queueReservations = tempList;
        });
      }
    });
  }

  @override
  void dispose() {
    _reservationSubscription?.cancel(); // Clean up the listener
    _reservationSubscriptionNonQueue?.cancel();
    super.dispose();
  }

  // 🔹 Update reservation status (Assign -> Queue)
  void _updateReservationStatus(String id, String name, String time,
      int numberofPeople, int? selectedAddTable) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");

    String newId =
        dbRef.push().key ?? DateTime.now().millisecondsSinceEpoch.toString();

    DateTime now = DateTime.now();

    // Convert waitingTime to Duration
    List<String> timeParts = time.split(":");
    int minutes = 0;
    if (timeParts.length == 2) {
      minutes = int.tryParse(timeParts[0])! * 60 + int.tryParse(timeParts[1])!;
    }

    DateTime expiryTime = now.add(Duration(minutes: minutes));

    dbRef.child(newId).set({
      "name": name,
      "numberOfPeople": numberofPeople,
      "time": time,
      "restaurantName": hotelName,
      "status": "Queue",
      "createdAt": now.toIso8601String(),
      "expiryTime": expiryTime.toIso8601String(),

      // ✅ Add assigned table
      "assignedTable": selectedAddTable,
    }).then((_) {
      _fetchQueueReservations();
      Navigator.pop(context);
    });
  }

  void _removeReservationFromQueue(String id) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations").child(id);

    dbRef.remove().then((_) {
      _fetchQueueReservations(); // Refresh list after deletion
    });
  }

  void _addUserToQueue(String name, int numberOfPeople, String waitingTime,
      int? selectedAddTable, String? id) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");

    String newId =
        dbRef.push().key ?? DateTime.now().millisecondsSinceEpoch.toString();

    DateTime now = DateTime.now();

    // Convert waitingTime to Duration
    List<String> timeParts = waitingTime.split(":");
    int minutes = 0;
    if (timeParts.length == 2) {
      minutes = int.tryParse(timeParts[0])! * 60 + int.tryParse(timeParts[1])!;
    }

    DateTime expiryTime = now.add(Duration(minutes: minutes));

    dbRef.child(newId).set({
      "name": name,
      "numberOfPeople": numberOfPeople,
      "time": waitingTime,
      "restaurantName": hotelName,
      "status": "Queue",
      "createdAt": now.toIso8601String(),
      "expiryTime": expiryTime.toIso8601String(),

      // ✅ Add assigned table
      "assignedTable": selectedAddTable,
    }).then((_) {
      _fetchQueueReservations();
      Navigator.pop(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$hotelName Dashboard")),
      body: _selectedIndex == 0 ? _buildAssignTab() : _buildQueueTab(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Assign'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // 🔹 Assign Tab: Filtered reservations
  Widget _buildAssignTab() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: reservations.map((reservation) {
              final reservationId = reservation["id"];
              selectedTables.putIfAbsent(reservationId, () => null);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reservation["name"] ?? "Unknown",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                          "${reservation["numberOfPeople"]} people at ${reservation["restaurantName"]}"),
                      SizedBox(height: 10),
                      DropdownButton<int>(
                        hint: Text("Select Table"),
                        value: selectedTables[reservationId],
                        items: tableList.map<DropdownMenuItem<int>>((table) {
                          return DropdownMenuItem<int>(
                            value: table,
                            child: Text("Table $table"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTables[reservationId] = value!;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: timeControllers[reservationId],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                TimeInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                hintText: "HH:MM",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              String time =
                                  timeControllers[reservationId]?.text ??
                                      "00:00";
                              int? tableSize = selectedTables[reservationId];
                              _updateReservationStatus(
                                  reservation["id"],
                                  reservation["name"],
                                  time,
                                  int.parse(reservation['numberOfPeople']),
                                  tableSize);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _showAddUserDialog,
          child: Text("Add User"),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQueueTab() {
    return ListView(
      children: queueReservations.asMap().entries.map((entry) {
        int index = entry.key + 1;
        Map<String, dynamic> reservation = entry.value;

        return Dismissible(
          key: Key(reservation["id"]),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _removeReservationFromQueue(reservation["id"]);
          },
          child: QueueReservationTile(
            index: index,
            reservation: reservation,
            onExpire: _removeReservationFromQueue,
          ),
        );
      }).toList(),
    );
  }

  // 🔹 Show Add User Dialog
  void _showAddUserDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController peopleController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    selectedAddTable = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New User"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: peopleController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Number of People"),
                ),
                TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    TimeInputFormatter(),
                  ],
                  decoration:
                      InputDecoration(labelText: "Waiting Time (HH:MM)"),
                ),
                SizedBox(height: 10),
                DropdownButton<int>(
                  isExpanded: true,
                  hint: Text("Select Table"),
                  value: selectedAddTable,
                  items: tableList.map<DropdownMenuItem<int>>((table) {
                    return DropdownMenuItem<int>(
                      value: table,
                      child: Text("Table $table"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAddTable = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _addUserToQueue(
                    nameController.text,
                    int.tryParse(peopleController.text) ?? 1,
                    timeController.text,
                    selectedAddTable,
                    "");
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4) text = text.substring(0, 4);

    String formatted = text.length >= 3
        ? "${text.substring(0, 2)}:${text.substring(2)}"
        : text;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
