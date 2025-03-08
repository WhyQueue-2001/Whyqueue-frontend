// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:whyqueue/Screens/Login.dart';

// class RestaurantInputScreen extends StatefulWidget {
//   @override
//   _RestaurantInputScreenState createState() => _RestaurantInputScreenState();
// }

// class _RestaurantInputScreenState extends State<RestaurantInputScreen> {
//   final _formKey = GlobalKey<FormState>();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController fssaiController = TextEditingController();
//   TextEditingController otherCuisineController = TextEditingController();

//   List<String> selectedCuisines = [];
//   bool showOtherCuisineField = false;

//   final List<String> cuisines = [
//     "North Indian",
//     "Chinese",
//     "Fast Food",
//     "South Indian",
//     "Biryani",
//     "Dessert",
//     "Other"
//   ];

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       List<String> finalCuisines = List.from(selectedCuisines);
//       if (showOtherCuisineField && otherCuisineController.text.isNotEmpty) {
//         finalCuisines.add(otherCuisineController.text);
//       }

//       DatabaseReference dbRef =
//           FirebaseDatabase.instance.ref().child("restaurants");

//       String newRestaurantKey = dbRef.push().key!;

//       Map<String, dynamic> restaurantData = {
//         "restaurantName": nameController.text,
//         "address": addressController.text,
//         "contact": contactController.text,
//         "email": emailController.text,
//         "cuisines": finalCuisines,
//         "fssaiNumber": fssaiController.text,
//       };

//       dbRef.child(newRestaurantKey).set(restaurantData).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Data saved to Firebase!"),
//               backgroundColor: Colors.green),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Failed: $error"), backgroundColor: Colors.red),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Restaurant Input Form"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepPurple.shade900, Colors.orange.shade600],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Card(
//             elevation: 10,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildTextField("Restaurant Name", nameController),
//                     buildTextField("Complete Address", addressController),
//                     buildTextField("Contact Number", contactController,
//                         isNumeric: true),
//                     buildTextField("Email", emailController, isEmail: true),
//                     buildMultiSelectCuisines(),
//                     if (showOtherCuisineField)
//                       buildTextField(
//                           "Enter Your Cuisine", otherCuisineController),
//                     buildTextField("FSSAI Number", fssaiController,
//                         isNumeric: true),
//                     SizedBox(height: 20),
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: _submitForm,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           padding: EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 40),
//                         ),
//                         child: Text("Submit",
//                             style:
//                                 TextStyle(fontSize: 18, color: Colors.white)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(String label, TextEditingController controller,
//       {bool isNumeric = false, bool isEmail = false}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: isNumeric
//             ? TextInputType.number
//             : isEmail
//                 ? TextInputType.emailAddress
//                 : TextInputType.text,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return "Please enter $label";
//           }
//           if (isEmail &&
//               !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$").hasMatch(value)) {
//             return "Please enter a valid email";
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget buildMultiSelectCuisines() {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Select Cuisine(s)",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           Wrap(
//             children: cuisines.map((cuisine) {
//               return Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Checkbox(
//                     value: selectedCuisines.contains(cuisine),
//                     onChanged: (bool? value) {
//                       setState(() {
//                         if (value == true) {
//                           selectedCuisines.add(cuisine);
//                           if (cuisine == "Other") {
//                             showOtherCuisineField = true;
//                           }
//                         } else {
//                           selectedCuisines.remove(cuisine);
//                           if (cuisine == "Other") {
//                             showOtherCuisineField = false;
//                             otherCuisineController.clear();
//                           }
//                         }
//                       });
//                     },
//                   ),
//                   Text(cuisine),
//                 ],
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whyqueue/Screens/Login.dart';
import 'dart:math';

class RestaurantInputScreen extends StatefulWidget {
  @override
  _RestaurantInputScreenState createState() => _RestaurantInputScreenState();
}

class _RestaurantInputScreenState extends State<RestaurantInputScreen> {
  final _formKey = GlobalKey<FormState>();

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      List<String> finalCuisines = List.from(selectedCuisines);
      if (showOtherCuisineField && otherCuisineController.text.isNotEmpty) {
        finalCuisines.add(otherCuisineController.text);
      }

      // Create a reference to Firebase Database
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child("restaurants");

      // Generate a unique ID for each restaurant
      String newRestaurantKey = dbRef.push().key!;

      // Generate unique username and password
      String username = "user_" + _generateRandomString(8);
      String password = _generateRandomString(12);

      // Prepare data
      Map<String, dynamic> restaurantData = {
        "restaurantName": nameController.text,
        "address": addressController.text,
        "contact": contactController.text,
        "email": emailController.text,
        "cuisines": finalCuisines,
        "fssaiNumber": fssaiController.text,
        "username": username,
        "password": password,
      };

      // Store data in Firebase
      dbRef.child(newRestaurantKey).set(restaurantData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Data saved to Firebase!"),
              backgroundColor: Colors.green),
        );

        // Print username and password to console
        print("Generated Username: $username");
        print("Generated Password: $password");

        // Navigate to Login Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
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
