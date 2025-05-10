// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class UserLandingPage extends StatefulWidget {
//   const UserLandingPage({super.key});

//   @override
//   _UserLandingPageState createState() => _UserLandingPageState();
// }

// class _UserLandingPageState extends State<UserLandingPage> {
//   final DatabaseReference _dbRef =
//       FirebaseDatabase.instance.ref().child("restaurants");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Restaurants List"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: StreamBuilder(
//         stream: _dbRef.onValue,
//         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(
//               child: Text(
//                 "No data available",
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           Map<dynamic, dynamic> data =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           List<Map<String, dynamic>> restaurants = [];

//           data.forEach((key, value) {
//             restaurants.add(Map<String, dynamic>.from(value));
//           });

//           return ListView.builder(
//             itemCount: restaurants.length,
//             itemBuilder: (context, index) {
//               var restaurant = restaurants[index];

//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 elevation: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Restaurant Image (Placeholder if no image available)
//                     Container(
//                       height: 180, // Increased image height
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(10),
//                         ),
//                         image: DecorationImage(
//                           image: restaurant["imageUrl"] != null
//                               ? NetworkImage(restaurant["imageUrl"])
//                               : AssetImage("assets/placeholder.jpg")
//                                   as ImageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),

//                     // Restaurant Details
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             restaurant["restaurantName"] ?? "Unknown",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "📍 ${restaurant["address"] ?? "No Address"}",
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.grey[700]),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "📞 ${restaurant["contact"] ?? "No Contact"}",
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.grey[700]),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "🍽️ Cuisines: ${restaurant["cuisines"].join(", ")}",
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.grey[700]),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:whyqueue/Screens/user_revervation_screen.dart';
import 'package:whyqueue/Screens/select_location_screen.dart'; // Make sure this import exists

class UserLandingPage extends StatefulWidget {
  const UserLandingPage({super.key});

  @override
  _UserLandingPageState createState() => _UserLandingPageState();
}

class _UserLandingPageState extends State<UserLandingPage> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("restaurants");

  final Color pistaColor = const Color(0xFFA0C49D);

  String selectedLocation = "Home";
  String address = "B-501 Darshnamclublife , Ahead of Nara...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: Home + location + profile circle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home + Location with GestureDetector
                  GestureDetector(
                    onTap: () async {
                      final selectedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectLocationScreen()),
                      );
                      if (selectedAddress != null) {
                        setState(() {
                          selectedLocation = selectedAddress["name"] ?? "Selected";
                          address = selectedAddress["address"] ?? "Selected Address";
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: pistaColor, size: 25),
                            SizedBox(width: 4),
                            Text(
                              selectedLocation,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.keyboard_arrow_down, size: 20),
                          ],
                        ),
                        SizedBox(height: 7),
                        Text(
                          address,
                          style: TextStyle(fontSize: 13.5, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  // Profile initials circle
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: pistaColor,
                    child: Text(
                      "Y",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            // Restaurant list
            Expanded(
              child: StreamBuilder(
                stream: _dbRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const Center(
                      child: Text("No data available", style: TextStyle(fontSize: 18)),
                    );
                  }

                  Map<dynamic, dynamic> data =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<Map<String, dynamic>> restaurants = [];

                  data.forEach((key, value) {
                    restaurants.add(Map<String, dynamic>.from(value));
                  });

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 16),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      var restaurant = restaurants[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QueueReservationsScreen(
                                hotelName: restaurant["restaurantName"] ?? "Unknown",
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          color: const Color.fromARGB(255, 224, 231, 220),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: restaurant["imageUrl"] != null
                                        ? NetworkImage(restaurant["imageUrl"])
                                        : const AssetImage("assets/placeholder.jpg") as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant["restaurantName"] ?? "Unknown",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "📍 ${restaurant["address"] ?? "No Address"}",
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
