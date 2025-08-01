import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

const String name = "Kunto Wicaksono";
const String position = "Software Engineer";
const String department = "HSE Digital Tranformation";
const String profileImage = "assets/img/profile.jpg";

const String employeeId = "9901";
const String employeeType = "Trainee";
const String dateOfJoin = "3 February 2025";

const String email = "kunto@solecode.id";
const String phone = "+62 812-3456-7890";
const String location = "Jakarta, Indonesia";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Attendance Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildProfileHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildContactInfo(context, "Contact Information"),
                  Divider(),
                  buildEmployeeInfo(context, "Emplyee Information"),
                ],
              ),
            ),
            Center(
              child: Text(
                "HR Attendance Tracker v1.0",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildProfileHeader(BuildContext context) {
  final today = DateTime.now();
  final date =
      "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";

  return Column(
    children: [
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 210,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Today's Date: $date",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Icon(Icons.edit, color: Colors.white),
          ),
          Positioned.fill(
            top: 60,
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipOval(
                child: Image.asset(
                  profileImage,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(name, style: Theme.of(context).textTheme.headlineLarge),
      Text(position, style: Theme.of(context).textTheme.bodyLarge),
    ],
  );
}

Widget buildContactInfo(BuildContext context, title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          ProfileItem(title: 'Email', subtitle: email, icon: Icons.email),
          ProfileItem(title: 'Phone', subtitle: phone, icon: Icons.phone),
          ProfileItem(
            title: 'Location',
            subtitle: location,
            icon: Icons.location_on,
          ),
        ],
      ),
    ),
  );
}

Widget buildEmployeeInfo(BuildContext context, title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          ProfileItem(
            title: "Employee ID",
            subtitle: employeeId,
            icon: Icons.badge,
          ),
          ProfileItem(
            title: "Employee Type",
            subtitle: employeeType,
            icon: Icons.work,
          ),
          ProfileItem(
            title: "Date of Joining",
            subtitle: dateOfJoin,
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ProfileItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.lightBlue.shade100,
        child: Icon(icon, size: 20, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
