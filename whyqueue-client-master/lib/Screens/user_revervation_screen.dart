import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:whyqueue/User/user_booking.dart';

class QueueReservationsScreen extends StatefulWidget {
  final String hotelName;

  const QueueReservationsScreen({super.key, required this.hotelName});

  @override
  _QueueReservationsScreenState createState() =>
      _QueueReservationsScreenState();
}

class _QueueReservationsScreenState extends State<QueueReservationsScreen> {
  List<Map<String, dynamic>> queueReservations = [];

  @override
  void initState() {
    super.initState();
    _fetchQueueReservations();
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
          if (value["restaurantName"] == widget.hotelName &&
              value["status"] == "Queue") {
            final reservation = Map<String, dynamic>.from(value);
            reservation["id"] = key.toString();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 248, 239), // Light green background
      appBar: AppBar(
        title: Text("${widget.hotelName} - Queue Reservations"),
        backgroundColor: const Color.fromARGB(255, 244, 248, 239),// Dark green app bar
      ),
      body: queueReservations.isEmpty
          ? Center(
              child: Text(
                "No reservations in queue",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: queueReservations.length,
              itemBuilder: (context, index) {
                var reservation = queueReservations[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reservation ID: ${reservation["id"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "📅 Date: ${reservation["date"] ?? "Unknown"}",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "🕒 Time: ${reservation["time"] ?? "Unknown"}",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "👤 Customer: ${reservation["name"] ?? "No Name"}",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: queueReservations.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  _handlePayment(widget.hotelName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 111, 141, 92) ,// Dark green button
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }

  void _handlePayment(String hotelName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          hotelName: hotelName,
        ),
      ),
    );
  }
}
