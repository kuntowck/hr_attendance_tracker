import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> attendanceData = [
      {
        "date": "08-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
      {
        "date": "08-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
      {
        "date": "08-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
      {
        "date": "08-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
      {
        "date": "08-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
      {
        "date": "07-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
      {
        "date": "06-08-2025",
        "checkIn": "-",
        "checkOut": "-",
        "status": "Absent",
      },
      {
        "date": "05-08-2025",
        "checkIn": "-",
        "checkOut": "-",
        "status": "Absent",
      },
      {
        "date": "04-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
      {
        "date": "03-08-2025",
        "checkIn": "-",
        "checkOut": "-",
        "status": "Absent",
      },
      {
        "date": "02-08-2025",
        "checkIn": "08:00 AM",
        "checkOut": "17:00 PM",
        "status": "Present",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance History")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: ListView.separated(
              itemCount: attendanceData.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = attendanceData[index];
                return _tile(item);
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget _tile(item) {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.calendar_today, color: Colors.blue, size: 20),
      ),
      title: Text(
        item["date"]!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Check In: ${item["checkIn"]}"),
          Text("Check Out: ${item["checkOut"]}"),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: item["status"] == "Present"
              ? Colors.green.shade100
              : Colors.red.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          item["status"]!,
          style: TextStyle(
            color: item["status"] == "Present" ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
