import 'dart:async';
import 'package:flutter/material.dart';

class QueueReservationTile extends StatefulWidget {
  final int index;
  final Map<String, dynamic> reservation;

  const QueueReservationTile({
    Key? key,
    required this.index,
    required this.reservation,
  }) : super(key: key);

  @override
  _QueueReservationTileState createState() => _QueueReservationTileState();
}

class _QueueReservationTileState extends State<QueueReservationTile> {
  late Duration remainingTime;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
  }

  void _initializeCountdown() {
    String? timeStr = widget.reservation["time"];
    if (timeStr != null) {
      // Assuming time is in "HH:MM" format where MM is minutes (e.g., "00:42" means 42 minutes)
      List<String> parts = timeStr.split(":");
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts.length > 1 ? parts[1] : "0") ?? 0;

      remainingTime = Duration(hours: hours, minutes: minutes);
    } else {
      remainingTime = Duration.zero;
    }

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingTime = remainingTime - Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration d) {
    String hours = d.inHours.toString().padLeft(2, '0');
    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(widget.index.toString(),
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(widget.reservation["name"] ?? "No Name",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text("Time Left: ${_formatDuration(remainingTime)}"),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';

// class QueueReservationTile extends StatefulWidget {
//   final int index;
//   final Map<String, dynamic> reservation;

//   const QueueReservationTile({
//     Key? key,
//     required this.index,
//     required this.reservation,
//   }) : super(key: key);

//   @override
//   _QueueReservationTileState createState() => _QueueReservationTileState();
// }

// class _QueueReservationTileState extends State<QueueReservationTile> {
//   late Duration initialTime;
//   late Duration remainingTime;
//   Timer? countdownTimer;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCountdown();
//   }

//   void _initializeCountdown() {
//     String? timeStr = widget.reservation["time"];
//     if (timeStr != null) {
//       List<String> parts = timeStr.split(":");
//       int hours = int.tryParse(parts[0]) ?? 0;
//       int minutes = int.tryParse(parts.length > 1 ? parts[1] : "0") ?? 0;

//       initialTime = Duration(hours: hours, minutes: minutes);
//     } else {
//       initialTime = Duration.zero;
//     }

//     remainingTime = initialTime;

//     countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (remainingTime.inSeconds <= 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           remainingTime -= Duration(seconds: 1);
//         });
//       }
//     });
//   }

//   double _progressPercent() {
//     if (initialTime.inSeconds == 0) return 0.0;
//     return remainingTime.inSeconds / initialTime.inSeconds;
//   }

//   String _formatDuration(Duration d) {
//     String hours = d.inHours.toString().padLeft(2, '0');
//     String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     return "$hours:$minutes";
//   }

//   @override
//   void dispose() {
//     countdownTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: ListTile(
//         leading: Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               width: 50,
//               height: 50,
//               child: CircularProgressIndicator(
//                 value: _progressPercent(),
//                 strokeWidth: 5,
//                 backgroundColor: Colors.grey.shade300,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//               ),
//             ),
//             Text(
//               widget.index.toString(),
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         title: Text(
//           widget.reservation["name"] ?? "No Name",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           "Time Left: ${_formatDuration(remainingTime)}",
//           style: TextStyle(fontSize: 14),
//         ),
//       ),
//     );
//   }
// }
