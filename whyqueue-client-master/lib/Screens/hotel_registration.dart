import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whyqueue/Screens/Login.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class RestaurantInputScreen extends StatefulWidget {
  @override
  _RestaurantInputScreenState createState() => _RestaurantInputScreenState();
}

class _RestaurantInputScreenState extends State<RestaurantInputScreen> {
  final _formKey = GlobalKey<FormState>();

  List<int> tableOptions = [2, 4, 6, 8, 10, 12];
  List<int> selectedTables = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController fssaiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otherCuisineController = TextEditingController();

  List<String> selectedCuisines = [];
  bool showOtherCuisineField = false;

  final List<String> cuisines = [
    "North Indian",
    "Chinese",
    "Fast Food",
    "South Indian",
    "Biryani",
    "Dessert",
    "Other"
  ];

  String _generateRandomString(int length) {
    const chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Widget buildMultiSelectTables() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Table Sizes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 10.0,
            children: tableOptions.map((table) {
              return FilterChip(
                label: Text("$table Seater"),
                selected: selectedTables.contains(table),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedTables.add(table);
                    } else {
                      selectedTables.remove(table);
                    }
                  });
                },
                selectedColor: Colors.deepPurple.shade200,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      List<String> finalCuisines = List.from(selectedCuisines);
      if (showOtherCuisineField && otherCuisineController.text.isNotEmpty) {
        finalCuisines.add(otherCuisineController.text);
      }

      String email = emailController.text;
      String username = "user_" + _generateRandomString(8);
      String password = _generateRandomString(12);

      // Prepare email payload
      Map<String, dynamic> emailPayload = {
        "email": email,
        "username": username,
        "password": password,
      };

      try {
        // Send email request to your backend
        final response = await http.post(
          Uri.parse(
              'https://9704-115-246-20-252.ngrok-free.app/mail/send-email'), // Replace with your backend endpoint
          headers: {'Content-Type': 'application/json'},
          body: json.encode(emailPayload),
        );

        if (response.statusCode == 200) {
          // Email sent successfully, store data in Firebase
          DatabaseReference dbRef =
              FirebaseDatabase.instance.ref().child("restaurants");
          String newRestaurantKey = dbRef.push().key!;

          Map<String, dynamic> restaurantData = {
            "restaurantName": nameController.text,
            "address": addressController.text,
            "contact": contactController.text,
            "email": email,
            "cuisines": finalCuisines,
            "fssaiNumber": fssaiController.text,
            "username": username,
            "password": password,
            "tableSizes": selectedTables,
          };

          await dbRef.child(newRestaurantKey).set(restaurantData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Email sent and data saved successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to Login Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to send email: ${response.body}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send email: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Input Form"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField("Restaurant Name", nameController),
                    buildTextField("Complete Address", addressController),
                    buildTextField("Contact Number", contactController,
                        isNumeric: true),
                    buildTextField("Email", emailController, isEmail: true),
                    buildMultiSelectCuisines(),
                    buildMultiSelectTables(),
                    if (showOtherCuisineField)
                      buildTextField(
                          "Enter Your Cuisine", otherCuisineController),
                    buildTextField("FSSAI Number", fssaiController,
                        isNumeric: true),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                        ),
                        child: Text("Submit",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false, bool isEmail = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric
            ? TextInputType.number
            : isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          if (isEmail &&
              !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
            return "Please enter a valid email";
          }
          return null;
        },
      ),
    );
  }

  Widget buildMultiSelectCuisines() {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Cuisine(s)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Wrap(
            children: cuisines.map((cuisine) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: selectedCuisines.contains(cuisine),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedCuisines.add(cuisine);
                          if (cuisine == "Other") {
                            showOtherCuisineField = true;
                          }
                        } else {
                          selectedCuisines.remove(cuisine);
                          if (cuisine == "Other") {
                            showOtherCuisineField = false;
                            otherCuisineController.clear();
                          }
                        }
                      });
                    },
                  ),
                  Text(cuisine),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
