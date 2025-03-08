import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whyqueue/Screens/user_view.dart';
import 'package:whyqueue/Screens/hotel_registration.dart';
import 'package:whyqueue/Screens/user_registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String otp = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter username and password")),
      );
      setState(() => _isLoading = false);
      return;
    }

    const String apiUrl =
        "http://192.168.29.211:3000/login/loginCredebtial"; // Update API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful!")),
        );
        // Navigate to next screen (Dashboard or Home)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"] ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Login with Password"),
                Tab(text: "Login with OTP"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Username & Password Login
                  _buildPasswordLogin(),
                  // OTP Login
                  _buildOtpLogin(),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => UserLandingPage()));
              },
              child: Text("Enter as User"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantInputScreen()));
              },
              child: Text(" Register for Hotels"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
              labelText: 'Username', border: OutlineInputBorder()),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'Password', border: OutlineInputBorder()),
        ),
        SizedBox(height: 24),
        _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {}, // Implement login logic
                child: Text('Login'),
              ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegistrationPage()),
            );
          },
          child: Text('New User? Register Here'),
        ),
      ],
    );
  }

  Widget _buildOtpLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _emailController,
          decoration:
              InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => sendOtp("Email"),
          child: Text("Send OTP via Email"),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
              labelText: 'Phone Number', border: OutlineInputBorder()),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => sendOtp("Phone"),
          child: Text("Send OTP via Phone"),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _otpController,
          decoration: InputDecoration(
              labelText: 'Enter OTP', border: OutlineInputBorder()),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (otp == _otpController.text) {
              print("LOgin Succesfull");
            }
          },
          child: Text("Verify OTP"),
        ),
      ],
    );
  }
}
