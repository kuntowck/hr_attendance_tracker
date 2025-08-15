import 'package:flutter/material.dart';

class AttendanceStatus extends StatelessWidget {
  final String status;

  const AttendanceStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: status == "Present"
            ? Colors.green.shade50
            : status == "In Progress"
            ? Colors.lightBlue.shade50
            : status == "Unknown"
            ? Colors.blueGrey.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == "Present"
              ? Colors.green
              : status == "In Progress"
              ? Colors.blue
              : status == "Unknown"
              ? Colors.blueGrey
              : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
