import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/app_version.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildWelcomeHeader(context),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              buildAppInfoCard(context, "About This App"),
            ],
          ),
        ),
        AppVersion(),
      ],
    );
  }

  Widget buildWelcomeHeader(BuildContext context) {
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

  Widget buildAppInfoCard(BuildContext context, String title) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
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
    );
  }
}
