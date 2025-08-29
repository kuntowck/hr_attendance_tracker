import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';
import 'package:hr_attendance_tracker/providers/attendance_provider.dart';
import 'package:hr_attendance_tracker/widgets/attendance_status.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.read<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Logs'),
            Tab(text: 'Attendance'),
            Tab(text: 'Shift'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildProjectList(attendanceProvider, 'Logs'),
          buildProjectList(attendanceProvider, 'Attendance'),
          buildProjectList(attendanceProvider, 'Shift'),
        ],
      ),
    );
  }
}

Widget buildProjectList(AttendanceProvider attendanceProvider, String tabName) {
  if (attendanceProvider.mergedRecords.isEmpty) {
    return const Center(child: Text('No logs found'));
  }
  List<AttendanceModel> records = [];

  if (tabName == 'Logs') {
    records = attendanceProvider.mergedRecords;
  }

  if (tabName == 'Attendance') {
    records = attendanceProvider.mergedRecords
        .where((record) => record.checkOut == null)
        .toList();
  }

  if (tabName == 'Shift') return const Center(child: Text('No request yet'));

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView.separated(
      itemCount: records.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final item = records[index];
        return _tile(item, attendanceProvider);
      },
    ),
  );
}

Widget _tile(item, provider) {
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
        item.date != null ? DateFormat('EEEE, d MMM').format(item.date) : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Check In: ${item.checkIn != null ? DateFormat('HH:mm').format(item.checkIn) : '-'}",
          ),
          Text(
            "Check Out: ${item.checkOut != null ? DateFormat('HH:mm').format(item.checkOut) : '-'}",
          ),
          Text(
            "Duration: ${item.duration != null ? '${item.duration.inHours} jam ${item.duration.inMinutes.remainder(60)} menit' : '-'}",
          ),
        ],
      ),
      trailing: AttendanceStatus(status: item.status ?? '-'),
    ),
  );
}
