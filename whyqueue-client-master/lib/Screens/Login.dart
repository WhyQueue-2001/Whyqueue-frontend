import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whyqueue/Screens/otp_verfication.dart';
import 'package:whyqueue/Screens/restro_dashboard.dart';
import 'package:whyqueue/Screens/user_view.dart';
import 'package:whyqueue/Screens/hotel_registration.dart';
import 'package:whyqueue/Screens/user_registration.dart';
import 'package:whyqueue/User/user_booking.dart';
import 'package:flutter/material.dart';
import 'package:whyqueue/Screens/login_retro.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top curved background
              Container(
                width: double.infinity,
                height: 250,
                decoration: const BoxDecoration(
                  
                  gradient: LinearGradient(
                                   

                    colors: [Color.fromARGB(255, 197, 224, 180)
,
                     Color.fromARGB(255, 197, 224, 180)
],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Whyqueue',
                    style: TextStyle(
                      fontSize: 34,
                        fontFamily: 'RoboRegu',

                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Log in or sign up',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'RoboRegu',

                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    // Country code dropdown mock
                    Container(
  height: 50,
  padding: EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 4,
        offset: Offset(2, 2),
      ),
    ],
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        'assets/india.png', // Make sure you have this image in assets
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      ),
      SizedBox(width: 8),
      Icon(Icons.arrow_drop_down, color: Colors.black),
    ],
  ),
),

                    const SizedBox(width: 10),
                    // Mobile input
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Text("+91",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                )),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Mobile Number",
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 197, 224, 180)
,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OTPVerificationPage()),
    );
  },
  child: const Center(
    child: Text(
      'Continue',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'or',
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 15),

              // 3 social media icon placeholders
             Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Image.asset(
        'assets/google.png',
        fit: BoxFit.contain,
      ),
    ),
    SizedBox(width: 20),
    Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Image.asset(
        'assets/apple.png',
        fit: BoxFit.contain,
      ),
    ),
  ],
),



              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Divider(thickness: 1),
              ),

              const SizedBox(height: 20),

              // Register your hotel button
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30),
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RestaurantInputScreen()),
      );
    },
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 197, 224, 180),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Register your Hotel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  ),
),

              const SizedBox(height: 12),

              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30),
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginRetro()),
      );
    },
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 197, 224, 180),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Login Hotel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  ),
),

              const SizedBox(height: 25),

              // Terms and conditions
              const Text(
                'By continuing, you agree to our',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 5),
              Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLandingPage()),
        );
      },
      child: const Text(
        'Terms of Service',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black87,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
    const SizedBox(width: 8),
    GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLandingPage()),
        );
      },
      child: const Text(
        'Privacy Policy',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black87,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
    const SizedBox(width: 8),
    GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLandingPage()),
        );
      },
      child: const Text(
        'Content Policies',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black87,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  ],
),


              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}