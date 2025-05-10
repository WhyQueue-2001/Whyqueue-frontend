import 'package:flutter/material.dart';
import 'package:whyqueue/Screens/enter_address_screen.dart';

class SelectLocationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedAddresses = [
    {
      "label": "Home",
      "address":
          "B-501 Darshnamclublife, Ahead of Narayan garden next to kalp desire, Nr Pratham shrusti, Opp Yash complex 30 mtr road Gotri road Vadodara, 5 Floor, Gorwa",
      "distance": "0 m"
    },
    {
      "label": "Other",
      "address":
          "25 navnath nagar soc. behind GEB substation, gotri road, Vadodara, Saiyed Vasna",
      "distance": "3.4 km"
    },
    {
      "label": "Home",
      "address": "40, Subhanpura",
      "distance": "2.4 km"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 248, 239),
      appBar: AppBar(
        title: Text(
          "Select a location",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobbRegu',
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          // Search bar
         Padding(
  padding: const EdgeInsets.all(12.0),
  child: Material(
    elevation: 4,
    shadowColor: Colors.black45,
    borderRadius: BorderRadius.circular(12),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
        hintText: "Search for area, street name...",
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  ),
),

          // Add address + Use current location
          Container(
            color: const Color.fromARGB(255, 244, 248, 239),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.add, color: Colors.green),
                    title: Text("Add address"),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          reverseTransitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              EnterAddressScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            );
                            final slideAnimation = Tween<Offset>(
                              begin: Offset(0, 1),
                              end: Offset.zero,
                            ).animate(curvedAnimation);
                            return SlideTransition(position: slideAnimation, child: child);
                          },
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.my_location, color: Colors.blue),
                    title: Text("Use your current location"),
                    subtitle: Text("Panchvati, Vadodara"),
                    onTap: () {
                      // Use current location
                    },
                  ),
                ],
              ),
            ),
          ),

          // Saved addresses title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Center(
              child: Text(
                "--------- SAVED ADDRESSES ---------",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Saved address cards
          Expanded(
            child: ListView.builder(
              itemCount: savedAddresses.length,
              itemBuilder: (context, index) {
                final address = savedAddresses[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.home_outlined, color: Colors.deepPurple),
                    title: Text(address["label"], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(address["address"]),
                    trailing: Text(
                      address["distance"],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                      Navigator.pop(context, address["address"]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
