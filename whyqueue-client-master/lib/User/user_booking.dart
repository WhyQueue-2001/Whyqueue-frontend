import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a reference to Firebase Database
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child("reservations");

      // Generate a unique ID for each reservation
      String newReservationKey = dbRef.push().key!;

      // Prepare data
      Map<String, dynamic> reservationData = {
        "name": _nameController.text,
        "numberOfPeople": _peopleController.text,
        "restaurantName": _restaurantController.text,
      };

      // Store data in Firebase
      dbRef.child(newReservationKey).set(reservationData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Reservation saved to Firebase!"),
              backgroundColor: Colors.green),
        );

        // Clear the form fields
        _nameController.clear();
        _peopleController.clear();
        _restaurantController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed: $error"), backgroundColor: Colors.red),
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
              TextFormField(
                controller: _restaurantController,
                decoration: InputDecoration(labelText: 'Restaurant Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a restaurant name' : null,
              ),
              SizedBox(height: 20),
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
