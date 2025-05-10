import 'package:flutter/material.dart';
import 'dart:async';

import 'package:whyqueue/Screens/Login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Path to your logo in assets folder
          width: 150, // Adjust width as needed
          height: 150, // Adjust height as needed
        ),
      ),
    );
  }
}
