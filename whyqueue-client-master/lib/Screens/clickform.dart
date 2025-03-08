// import 'package:flutter/material.dart';
// import 'package:googleapis/sheets/v4.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class GoogleFormScreen extends StatefulWidget {
//   @override
//   _GoogleFormScreenState createState() => _GoogleFormScreenState();
// }

// class _GoogleFormScreenState extends State<GoogleFormScreen> {
//   final String googleFormUrl =
//       'https://docs.google.com/forms/d/1-mDm_KUwu5YTQjnBwvV5o4DimFFFbfgwCyEVv_L3L-I'; // Replace with your form link

//   List<List<dynamic>> responses = [];

//   Future<void> _openGoogleForm() async {
//     final Uri url = Uri.parse(googleFormUrl);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.inAppBrowserView);
//     } else {
//       debugPrint('Could not launch $googleFormUrl');
//     }
//   }

//   Future<List<List<String>>> fetchGoogleSheetData() async {
//     // Replace with your Google Sheet ID and range
//     final String spreadsheetId = '1HckSkev2zj3_Pbhph2BL9BxZzlAIFD8JqNPfVZv3jew';
//     final String range =
//         'Form Responses 1!A1:R10'; // Adjust the range as needed

//     // Authenticate using API key or OAuth
//     final http.Client client = auth.clientViaApiKey(
//       'AIzaSyBizKnc1wQLieJM7sTI52--IxNPyuCyM0A',
//     );

//     // Initialize the Sheets API
//     final SheetsApi sheetsApi = SheetsApi(client);

//     // Fetch data from the sheet
//     final ValueRange response = await sheetsApi.spreadsheets.values.get(
//       spreadsheetId,
//       range,
//     );

//     // Parse the data
//     List<List<String>> data = [];
//     if (response.values != null) {
//       data = response.values!
//           .map((row) => row.map((cell) => cell.toString()).toList())
//           .toList();
//     }

//     // Close the client
//     client.close();

//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Google Form & Responses')),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Center(
//             child: ElevatedButton(
//               onPressed: _openGoogleForm,
//               child: Text('Open Form'),
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: fetchGoogleSheetData,
//             child: Text('Show Responses'),
//           ),
//           Expanded(
//             child: responses.isEmpty
//                 ? Center(child: Text("No responses yet"))
//                 : ListView.builder(
//                     itemCount: responses.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text("Response ${index + 1}"),
//                         subtitle: Text(responses[index].join(", ")),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class GoogleFormDataScreen extends StatefulWidget {
// //   @override
// //   _GoogleFormDataScreenState createState() => _GoogleFormDataScreenState();
// // }

// // class _GoogleFormDataScreenState extends State<GoogleFormDataScreen> {
// //   late Future<List<List<String>>> futureData;

// //   @override
// //   void initState() {
// //     super.initState();
// //     futureData = fetchGoogleSheetData();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Google Form Data'),
// //       ),
// //       body: FutureBuilder<List<List<String>>>(
// //         future: futureData,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return Center(child: Text('No data found.'));
// //           } else {
// //             final data = snapshot.data!;
// //             return ListView.builder(
// //               itemCount: data.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text(data[index].join(', ')),
// //                 );
// //               },
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SheetDataScreen extends StatefulWidget {
  const SheetDataScreen({super.key});

  @override
  _SheetDataScreenState createState() => _SheetDataScreenState();
}

class _SheetDataScreenState extends State<SheetDataScreen> {
  List<List<dynamic>> _data = [];
  final String url =
      'https://script.google.com/macros/s/AKfycbw2XuNVPffpIg6LVHpIqsEn2ZNJBK3hTECt9FPZ22qPhQbQ649c3ti8KTae09Cs2ilc/exec';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<List<dynamic>> sheetData =
            List<List<dynamic>>.from(json.decode(response.body));
        setState(() {
          _data = sheetData;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sheet Data')),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_data[index].join(' | ')), // Display row data
                );
              },
            ),
    );
  }
}
