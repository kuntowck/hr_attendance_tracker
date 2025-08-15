import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/attendance_provider.dart';
import 'package:hr_attendance_tracker/widgets/app_version.dart';
import 'package:hr_attendance_tracker/widgets/attendance_status.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();

    return Column(
      children: [
        welcomeHeader(context),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              appInfoCard(context, "About This App"),
              const SizedBox(height: 16),
              attendanceRecord(context, attendanceProvider),
            ],
          ),
        ),
        AppVersion(),
      ],
    );
  }

  Widget welcomeHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Aboard 👋🏼",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appInfoCard(BuildContext context, String title) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              "HR Attendance Tracker is a mobile app designed to help employees easily manage their attendance and personal info from their smartphones.",
            ),
          ],
        ),
      ),
    );
  }

  Widget attendanceRecord(BuildContext context, provider) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.formattedDate,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (provider.isCheckedIn) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in:'),
                      Text(
                        provider.record.checkIn,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  AttendanceStatus(status: provider.record.status),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.isCheckedIn
                        ? null
                        : () {
                            provider.checkIn();
                          },
                    child: Text('Check-in'),
                  ),
                ),
                const SizedBox(width: 8),
                if (provider.record != null) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<AttendanceProvider>().checkOut(),
                      child: Text('Check-out'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
