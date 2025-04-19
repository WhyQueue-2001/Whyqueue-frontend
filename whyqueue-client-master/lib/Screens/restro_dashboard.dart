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

  String get hotelName => widget.hotelData?['restaurantName'] ?? 'Unknown';

  @override
  void initState() {
    super.initState();
    _fetchReservations();
    _fetchQueueReservations();
  }

  // 🔹 Fetch reservations filtered by hotel name (non-queue)
  void _fetchReservations() {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");
    dbRef.onValue.listen((event) {
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

    dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> tempList = [];

        data.forEach((key, value) {
          if (value["restaurantName"] == hotelName &&
              value["status"] == "Queue") {
            // Cast all keys in 'value' map to String
            final reservation = Map<String, dynamic>.from(value);
            reservation["id"] = key.toString(); // Add ID from Firebase
            tempList.add(reservation);
          }
        });

        // Sort by the order of entry (Firebase keys are generally timestamp-based)
        tempList.sort((a, b) => a["id"].compareTo(b["id"]));

        setState(() {
          queueReservations = tempList;
        });
      }
    });
  }

  // 🔹 Update reservation status (Assign -> Queue)
  void _updateReservationStatus(String id, String name, String time) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");

    dbRef.child(id).update({
      "name": name,
      "time": time,
      "restaurantName": hotelName,
      "status": "Queue",
    });

    _fetchQueueReservations();
  }

  void _removeReservationFromQueue(String id) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations").child(id);

    dbRef.remove().then((_) {
      _fetchQueueReservations(); // Refresh list after deletion
    });
  }

  // 🔹 Add a new user entry filtered by hotel name
  void _addUserToQueue(String name, int numberOfPeople, String waitingTime) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");

    String newId =
        dbRef.push().key ?? DateTime.now().millisecondsSinceEpoch.toString();

    dbRef.child(newId).set({
      "name": name,
      "numberOfPeople": numberOfPeople,
      "time": waitingTime,
      "restaurantName": hotelName, // Associate with current hotel
      "status": "Queue",
    }).then((_) {
      _fetchQueueReservations();
      Navigator.pop(context); // Close the dialog box
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
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: timeControllers[reservation["id"]],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                TimeInputFormatter(), // Custom formatter for hh:mm
                              ],
                              decoration: InputDecoration(
                                hintText: "HH:MM",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              String time =
                                  timeControllers[reservation["id"]]?.text ??
                                      "00:00";
                              _updateReservationStatus(
                                  reservation["id"], reservation["name"], time);
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
          onPressed: () {
            _showAddUserDialog();
          },
          child: Text("Add User"),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // // 🔹 Queue Tab: Filtered queue reservations
  // Widget _buildQueueTab() {
  //   return ListView(
  //     children: queueReservations.asMap().entries.map((entry) {
  //       int index = entry.key + 1;
  //       Map<String, dynamic> reservation = entry.value;

  //       return Dismissible(
  //         key: Key(reservation["id"]),
  //         direction: DismissDirection.endToStart,
  //         background: Container(
  //           alignment: Alignment.centerRight,
  //           padding: EdgeInsets.symmetric(horizontal: 20),
  //           color: Colors.red,
  //           child: Icon(Icons.delete, color: Colors.white),
  //         ),
  //         onDismissed: (direction) {
  //           _removeReservationFromQueue(reservation["id"]);
  //         },
  //         child: Card(
  //           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //           child: ListTile(
  //             leading: CircleAvatar(
  //               child: Text(index.toString(),
  //                   style: TextStyle(fontWeight: FontWeight.bold)),
  //             ),
  //             title: Text(reservation["name"] ?? "No Name",
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             subtitle:
  //                 Text("Assigned Time: ${reservation["time"] ?? "Not Set"}"),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
  // Main widget
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
          child: QueueReservationTile(index: index, reservation: reservation),
        );
      }).toList(),
    );
  }

  // 🔹 Show Add User Dialog
  void _showAddUserDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController peopleController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New User"),
          content: Column(
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
                decoration: InputDecoration(labelText: "Waiting Time (HH:MM)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _addUserToQueue(
                  nameController.text,
                  int.tryParse(peopleController.text) ?? 1,
                  timeController.text,
                );
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
