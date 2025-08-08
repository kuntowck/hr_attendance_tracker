import 'package:flutter/material.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "HR Attendance Tracker v1.0",
        style: Theme.of(context).textTheme.labelSmall
      ),
    );
  }
}
