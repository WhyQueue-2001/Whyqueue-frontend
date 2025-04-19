import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whyqueue/Screens/Login.dart';
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

      Map<String, dynamic> emailPayload = {
        "email": email,
        "username": username,
        "password": password,
      };

      try {
        final response = await http.post(
          Uri.parse('https://9704-115-246-20-252.ngrok-free.app/mail/send-email'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(emailPayload),
        );

        if (response.statusCode == 200) {
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
        title: Text("Register Restaurant"),
        backgroundColor: const Color.fromARGB(255, 115, 192, 103),
      ),
      body: Container(
              color: Color(0xFFEFFFEA), // Changed from gradient to pista color

        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 15,
              color: Colors.white.withOpacity(0.95),
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("Restaurant Name", nameController,
                          icon: Icons.restaurant),
                      buildTextField("Complete Address", addressController,
                          icon: Icons.location_on),
                      buildTextField("Contact Number", contactController,
                          icon: Icons.phone, isNumeric: true),
                      buildTextField("Email", emailController,
                          icon: Icons.email, isEmail: true),
                      buildMultiSelectChips(),
                      if (showOtherCuisineField)
                        buildTextField(
                          "Enter Your Cuisine",
                          otherCuisineController,
                          icon: Icons.fastfood,
                        ),
                       buildMultiSelectTables(),
                      buildTextField("FSSAI Number", fssaiController,
                          icon: Icons.verified, isNumeric: true),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false,
      bool isEmail = false,
      IconData icon = Icons.text_fields}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric
            ? TextInputType.number
            : isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget buildMultiSelectChips() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Cuisine(s)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Wrap(
            spacing: 8,
            children: cuisines.map((cuisine) {
              final selected = selectedCuisines.contains(cuisine);
              return FilterChip(
                label: Text(cuisine),
                selected: selected,
                selectedColor: Colors.deepPurple.shade200,
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      selectedCuisines.add(cuisine);
                      if (cuisine == "Other") showOtherCuisineField = true;
                    } else {
                      selectedCuisines.remove(cuisine);
                      if (cuisine == "Other") {
                        showOtherCuisineField = false;
                        otherCuisineController.clear();
                      }
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
