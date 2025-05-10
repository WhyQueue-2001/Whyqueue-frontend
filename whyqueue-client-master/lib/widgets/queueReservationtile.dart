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
//   late Duration _remaining;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startCountdown();
//   }

//   void _startCountdown() {
//     _updateRemainingTime();
//     _timer =
//         Timer.periodic(Duration(seconds: 1), (_) => _updateRemainingTime());
//   }

//   void _updateRemainingTime() {
//     final expiryStr = widget.reservation['expiryTime'];
//     final expiry = DateTime.tryParse(expiryStr ?? '') ?? DateTime.now();
//     final now = DateTime.now();

//     setState(() {
//       _remaining = expiry.difference(now);
//       if (_remaining.isNegative) _remaining = Duration.zero;
//     });
//   }

//   String _formatDuration(Duration d) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final name = widget.reservation["name"] ?? "Unknown";
//     final people = widget.reservation["numberOfPeople"] ?? 0;
//     final isExpired = _remaining == Duration.zero;

//     return ListTile(
//       title: Text("${widget.index}. $name"),
//       subtitle: Text("$people people"),
//       trailing: Text(
//         isExpired ? "Expired" : _formatDuration(_remaining),
//         style: TextStyle(
//           color: isExpired ? Colors.red : Colors.green,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//     );
//   }
// }

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
//       // Assuming time is in "HH:MM" format where MM is minutes (e.g., "00:42" means 42 minutes)
//       List<String> parts = timeStr.split(":");
//       int hours = int.tryParse(parts[0]) ?? 0;
//       int minutes = int.tryParse(parts.length > 1 ? parts[1] : "0") ?? 0;

//       remainingTime = Duration(hours: hours, minutes: minutes);
//     } else {
//       remainingTime = Duration.zero;
//     }

//     countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (remainingTime.inSeconds <= 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           remainingTime = remainingTime - Duration(seconds: 1);
//         });
//       }
//     });
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
//         leading: CircleAvatar(
//           child: Text(widget.index.toString(),
//               style: TextStyle(fontWeight: FontWeight.bold)),
//         ),
//         title: Text(widget.reservation["name"] ?? "No Name",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         subtitle: Text("Time Left: ${_formatDuration(remainingTime)}"),
//       ),
//     );
//   }
// }

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

import 'dart:async';
import 'package:flutter/material.dart';

class QueueReservationTile extends StatefulWidget {
  final int index;
  final Map<String, dynamic> reservation;
  final Function(String id) onExpire;

  const QueueReservationTile({
    Key? key,
    required this.index,
    required this.reservation,
    required this.onExpire,
  }) : super(key: key);

  @override
  _QueueReservationTileState createState() => _QueueReservationTileState();
}

class _QueueReservationTileState extends State<QueueReservationTile> {
  late Duration _remaining;
  Timer? _timer;
  bool _expiredHandled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _updateRemainingTime();
    _timer =
        Timer.periodic(Duration(seconds: 1), (_) => _updateRemainingTime());
  }

  void _updateRemainingTime() {
    final expiryStr = widget.reservation['expiryTime'];
    final expiry = DateTime.tryParse(expiryStr ?? '') ?? DateTime.now();
    final now = DateTime.now();

    setState(() {
      _remaining = expiry.difference(now);

      if (_remaining.isNegative && !_expiredHandled) {
        _expiredHandled = true;
        _timer?.cancel();
        widget.onExpire(widget.reservation["id"]);
      }
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.reservation["name"] ?? "Unknown";
    final people = widget.reservation["numberOfPeople"] ?? 0;
    final isExpired = _remaining.isNegative;

    return ListTile(
      title: Text("${widget.index}. $name"),
      subtitle: Text("$people people"),
      trailing: Text(
        isExpired ? "Expired" : _formatDuration(_remaining),
        style: TextStyle(
          color: isExpired ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
