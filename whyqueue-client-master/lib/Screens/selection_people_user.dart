import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatelessWidget {
  const SeatSelectionScreen({super.key});

  void _showSeatSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const SeatSelectorSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book My Ride')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showSeatSelector(context),
          child: const Text("Select Number of People"),
        ),
      ),
    );
  }
}

class SeatSelectorSheet extends StatefulWidget {
  const SeatSelectorSheet({super.key});

  @override
  State<SeatSelectorSheet> createState() => _SeatSelectorSheetState();
}

class _SeatSelectorSheetState extends State<SeatSelectorSheet> {
  int selectedCount = 2;
  final int pricePerPerson = 10;

  @override
  Widget build(BuildContext context) {
    final int total = selectedCount * pricePerPerson;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'How many seats?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/bus.png', // Make sure to add this image to your assets
            height: 80,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            children: List.generate(10, (index) {
              int number = index + 1;
              bool isSelected = selectedCount == number;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCount = number;
                  });
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: isSelected ? Colors.red : Colors.grey[200],
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Use the selected value and amount elsewhere
            },
            child: Text(
              "$selectedCount People - ₹$total",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
