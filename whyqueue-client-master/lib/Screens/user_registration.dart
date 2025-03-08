import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String otp = " ";

  void verifyPhoneNumber() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification for Android (Automatically signs in user)
        await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Phone number automatically verified")),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verificationId to use for manual OTP entry
        setState(() {
          // _verificationId = verificationId;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP sent to $phoneNumber")),
        );

        // Show OTP input dialog
        // _showOtpInputDialog();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // _verificationId = verificationId;
      },
    );
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Send OTP"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  if (_emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter an email")),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  sendOtp(_emailController.text);
                },
                child: Text("Send OTP via Email"),
              ),
              TextButton(
                onPressed: () async {
                  verifyPhoneNumber();
                  if (_phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a phone number")),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  print("OTP sent via Phone");
                },
                child: Text("Send OTP via Phone"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> createUser(
      String username, String email, String phone, String password) async {
    final String apiUrl =
        "http://192.168.29.211:3000/users"; // Replace with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        print("User created successfully: ${response.body}");
      } else {
        print("Failed to create user: ${response.body}");
      }
    } catch (e) {
      print("Error creating user: $e");
    }
  }
// Future<void> getUserByUsername(String username) async {
//   final String apiUrl = "http://localhost:3000/users/username/$username"; // Replace with actual API URL

//   try {
//     final response = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       print("User found: ${response.body}");
//     } else {
//       print("User not found: ${response.body}");
//     }
//   } catch (e) {
//     print("Error fetching user: $e");
//   }
// }

  Future<void> sendOtp(String email) async {
    final String apiUrl = "http://192.168.29.211:3000/mail/send-otp";

    otp = (100000 +
            (999999 - 100000) *
                (new DateTime.now().millisecondsSinceEpoch % 1000000) /
                1000000)
        .toInt()
        .toString();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        print("OTP sent successfully: ${response.body}");
      } else {
        print("Failed to send OTP: ${response.body}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  Future<void> checkUsername(BuildContext context, String username) async {
    const String apiUrl =
        "http://192.168.29.211:3000/check/check-username"; // Update with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData["exists"] == true) {
          // Show Snackbar if username exists
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Username already taken. Please try another."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print("Error: ${responseData["message"]}");
      }
    } catch (e) {
      print("Error checking username: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  checkUsername(context, value);
                }
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showOtpDialog,
              child: Text('Send OTP'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_otpController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter the OTP")),
                  );
                  return;
                }

                if (_otpController.text != otp) {
                  // Compare entered OTP with generated OTP
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid OTP. Please try again.")),
                  );
                  return;
                }
                createUser(_usernameController.text, _emailController.text,
                    _phoneController.text, _passwordController.text);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
