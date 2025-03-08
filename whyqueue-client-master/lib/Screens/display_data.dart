import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleSheetScreen extends StatefulWidget {
  @override
  _GoogleSheetScreenState createState() => _GoogleSheetScreenState();
}

class _GoogleSheetScreenState extends State<GoogleSheetScreen> {
  List<List<dynamic>> data = [];

  Future<void> fetchData() async {
    final String sheetId =
        "1-mDm_KUwu5YTQjnBwvV5o4DimFFFbfgwCyEVv_L3L-I"; // Replace with your Sheet ID
    final String apiKey =
        "AIzaSyDajA124IRyA2Ev-hyX7vfjqr9cl8heQVU"; // Replace with your API Key
    final String url =
        "https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Sheet1?key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        data = List<List<dynamic>>.from(jsonData['values']);
      });
    } else {
      print("Failed to load data");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Form Data")),
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Response ${index + 1}"),
                  subtitle: Text(data[index].join(", ")), // Show row data
                );
              },
            ),
    );
  }
}
