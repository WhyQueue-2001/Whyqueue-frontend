import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:whyqueue/Screens/waititngScreen.dart';

class ReservationScreen extends StatefulWidget {
  final String hotelName;

  const ReservationScreen({super.key, required this.hotelName});
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();
  String? _fcmToken;
  @override
  void initState() {
    super.initState();
    // Initialize Firebase Database
    print("Widget: widget.hotelName");
    print("Widget: ${widget.hotelName}");
    _getFcmToken();
  }

  void _getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");
      setState(() {
        _fcmToken = token;
      });
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child("reservations");
      String newReservationKey = dbRef.push().key!;

      Map<String, dynamic> reservationData = {
        "name": _nameController.text,
        "numberOfPeople": _peopleController.text,
        "restaurantName": widget.hotelName,
        "fcmToken": _fcmToken,
      };

      dbRef.child(newReservationKey).set(reservationData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Reservation saved to Firebase!"),
            backgroundColor: Colors.green,
          ),
        );
        _nameController.clear();
        _peopleController.clear();

        // Delay for a short moment (optional)
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => SuccessScreen()),
          );
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed: $error"),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant Reservation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name of Person'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _peopleController,
                decoration: InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the number of people' : null,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
