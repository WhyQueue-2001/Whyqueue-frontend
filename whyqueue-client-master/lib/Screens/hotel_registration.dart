import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestaurantInputScreen extends StatefulWidget {
  @override
  _RestaurantInputScreenState createState() => _RestaurantInputScreenState();
}

class _RestaurantInputScreenState extends State<RestaurantInputScreen> {
  final _formKey = GlobalKey<FormState>();

  List<int> tableOptions = [2, 4, 6, 8, 10, 12];
  List<int> selectedTables = [];

  List<String> cuisines = [
    "North Indian",
    "Chinese",
    "Fast Food",
    "South Indian",
    "Biryani",
    "Dessert"
  ];
  List<String> selectedCuisines = [];

  TextEditingController cuisineInputController = TextEditingController();
  TextEditingController tableInputController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController fssaiController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String _generateRandomString(int length) {
    const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
          Uri.parse('https://4bd0-103-251-212-247.ngrok-free.app'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(emailPayload),
        );

        if (response.statusCode == 200) {
          DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("restaurants");
          String newRestaurantKey = dbRef.push().key!;

          Map<String, dynamic> restaurantData = {
            "restaurantName": nameController.text,
            "address": addressController.text,
            "contact": contactController.text,
            "email": email,
            "cuisines": selectedCuisines,
            "fssaiNumber": fssaiController.text,
            "username": username,
            "password": password,
            "tableSizes": selectedTables,
          };

          await dbRef.child(newRestaurantKey).set(restaurantData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email sent and data saved successfully!"), backgroundColor: Colors.green),
          );

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send email: ${response.body}"), backgroundColor: Colors.red),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send email: $error"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void addCuisine() {
    final text = cuisineInputController.text.trim();
    if (text.isNotEmpty && !cuisines.contains(text)) {
      setState(() {
        cuisines.add(text);
        selectedCuisines.add(text);
        cuisineInputController.clear();
      });
    }
  }

  void addTableSize() {
    final text = tableInputController.text.trim();
    if (text.isNotEmpty) {
      int? size = int.tryParse(text);
      if (size != null && !tableOptions.contains(size)) {
        setState(() {
          tableOptions.add(size);
          selectedTables.add(size);
          tableInputController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Restaurant"),
        backgroundColor: const Color(0xFF73C067),
      ),
      body: Container(
        color: Color.fromARGB(255, 197, 224, 180),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 15,
        color: Color(0xFFEFFFEA),
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("Restaurant Name", nameController, icon: Icons.restaurant),
                      buildTextField("Complete Address", addressController, icon: Icons.location_on),
                      buildTextField("Contact Number", contactController, icon: Icons.phone, isNumeric: true),
                      buildTextField("Email", emailController, icon: Icons.email, isEmail: true),

                      // Cuisine Selection
                      buildMultiSelectChips(
                        title: "Select Cuisine(s)",
                        options: cuisines,
                        selected: selectedCuisines,
                        onChanged: (value) => setState(() => selectedCuisines = value),
                      ),
                      buildAddOptionRow("Add Cuisine", cuisineInputController, addCuisine),

                      // Table Sizes
                      buildMultiSelectChips(
                        title: "Select Table Sizes",
                        options: tableOptions.map((e) => "$e Seater").toList(),
                        selected: selectedTables.map((e) => "$e Seater").toList(),
                        onChanged: (value) => setState(() =>
                        selectedTables = value.map((e) => int.parse(e.split(' ')[0])).toList()),
),

                      buildAddOptionRow("Add Table Size", tableInputController, addTableSize, isNumeric: true),

                      buildTextField("FSSAI Number", fssaiController, icon: Icons.verified, isNumeric: true),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF73C067),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
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
      {bool isNumeric = false, bool isEmail = false, IconData icon = Icons.text_fields}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Please enter $label";
          if (isEmail && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(value)) return "Enter a valid email";
          return null;
        },
      ),
    );
  }

  Widget buildMultiSelectChips({
    required String title,
    required List<String> options,
    required List<String> selected,
    required Function(List<String>) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Wrap(
            spacing: 8,
            children: options.map((option) {
              final isSelected = selected.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                selectedColor: const Color(0xFFBEE3A5),
                onSelected: (bool selectedNow) {
                  List<String> updatedSelected = List.from(selected);
                  if (selectedNow) {
                    updatedSelected.add(option);
                  } else {
                    updatedSelected.remove(option);
                  }
                  onChanged(updatedSelected);
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget buildAddOptionRow(
    String label,
    TextEditingController controller,
    VoidCallback onAdd, {
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF73C067),
              shape: CircleBorder(),
              padding: EdgeInsets.all(12),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
