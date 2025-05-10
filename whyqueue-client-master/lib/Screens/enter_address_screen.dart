import 'package:flutter/material.dart';

class EnterAddressScreen extends StatefulWidget {
  const EnterAddressScreen({super.key});

  @override
  State<EnterAddressScreen> createState() => _EnterAddressScreenState();
}

class _EnterAddressScreenState extends State<EnterAddressScreen> {
  String selectedTag = '';
  final TextEditingController _completeAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _completeAddressController.addListener(() {
      setState(() {}); // update UI when user types in the address
    });
  }

  bool _isFormValid() {
    return selectedTag.isNotEmpty && _completeAddressController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _completeAddressController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 244, 248, 239),
    appBar: AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 0,
    ),
    resizeToAvoidBottomInset: true, // Important
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16), // Space for the button
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color:  Color.fromARGB(255, 244, 248, 239),
                
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
                    
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Enter address details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    color: Colors.white,
                    child: const ListTile(
                      leading: Icon(Icons.call, color: Colors.black),
                      title: Text("Yash Dalia"),
                      subtitle: Text(
                        "9427224506",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      
                    ),
                  ),
                ],
              ),
            ),

            // Tags and Input Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tag this location for later",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildTag("Home", Icons.home),
                          _buildTag("Work", Icons.work),
                          _buildTag("Hotel", Icons.apartment),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                          "Complete Address *", _completeAddressController),
                      _buildInputField("Floor (Optional)", null),
                      _buildInputField("Landmark (Optional)", null),
                    ],
                  ),
                ),
              ),
            ),

            // Confirm Button
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      backgroundColor: _isFormValid()
          ? const Color.fromARGB(255, 111, 141, 92)
          : Colors.grey[400],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    onPressed: _isFormValid()
        ? () {
            // Confirm address action
          }
        : null,
    child: const Text(
      "Confirm address",
      style: TextStyle(color: Colors.white), // Set text color to white
    ),
  ),
),

          ],
        ),
      ),
    ),
  );
}


  // Selectable Tag Chip Builder
  Widget _buildTag(String label, IconData icon) {
    final bool isSelected = selectedTag == label;

    return Theme(
      data: Theme.of(context).copyWith(
        chipTheme: Theme.of(context).chipTheme.copyWith(
              showCheckmark: false,
            ),
      ),
      child: ChoiceChip(
        label: Text(label),
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : Colors.black,
        ),
        selected: isSelected,
        selectedColor: const Color(0xFFB3D89C),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
        onSelected: (_) {
          setState(() {
            selectedTag = label;
          });
        },
      ),
    );
  }

  // Input Field Builder
  Widget _buildInputField(String label, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
