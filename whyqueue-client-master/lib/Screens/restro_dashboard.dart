import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RestaurantDashboard extends StatefulWidget {
  @override
  _RestaurantDashboardState createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  void _fetchReservations() {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("reservations");
    dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> tempList = [];
        data.forEach((key, value) {
          tempList.add({"id": key, ...value});
        });
        setState(() {
          reservations = tempList;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> statuses = ["Assign", "Pending", "Started"];

    return Scaffold(
      appBar: AppBar(title: Text("Restaurant Dashboard")),
      body: ListView(
        children: reservations
            .where((res) =>
                res["status"] == statuses[_selectedIndex] ||
                res["status"] == null)
            .map((reservation) => ListTile(
                  title: Text(reservation["name"] ?? "Unknown"),
                  subtitle: Text(
                      "${reservation["numberOfPeople"]} people at ${reservation["restaurantName"]}"),
                  trailing: DropdownButton<String>(
                    value: reservation["status"] ?? "Assign",
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        DatabaseReference dbRef = FirebaseDatabase.instance
                            .ref()
                            .child("reservations");
                        dbRef
                            .child(reservation["id"])
                            .update({"status": newValue});
                      }
                    },
                    items: statuses.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                  ),
                ))
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Assign'),
          BottomNavigationBarItem(icon: Icon(Icons.pending), label: 'Pending'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow), label: 'Started'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
