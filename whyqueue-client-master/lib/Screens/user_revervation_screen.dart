import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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

  // Fetch reservations that are in Queue state
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
            tempList.add({"id": key, ...value});
          }
        });

        setState(() {
          queueReservations = tempList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.hotelName} - Queue Reservations"),
        backgroundColor: Colors.deepPurple,
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
                            color: Colors.deepPurple,
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
                          "👤 Customer: ${reservation["customerName"] ?? "No Name"}",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // Pay Now Button
      bottomNavigationBar: queueReservations.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  _handlePayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
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

  // Handle Payment Logic
  void _handlePayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Proceeding to payment..."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
