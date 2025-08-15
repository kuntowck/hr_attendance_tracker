import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/widgets/app_version.dart';

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

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 16.0,
            ),
            children: [
              profileHeader(context),
              const SizedBox(height: 16),
              contactInfo(context, "Contact Information"),
              const SizedBox(height: 16),
              employeeInfo(context, "Employee Information"),
            ],
          ),
        ),
        AppVersion(),
      ],
    );
  }
}

Widget profileHeader(BuildContext context) {
  final today = DateTime.now();
  final date =
      "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";

  return Column(
    children: [
      Stack(
        children: [
          Container(
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
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 45,
            child: Icon(Icons.edit, color: Colors.blue),
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

Widget contactInfo(BuildContext context, title) {
  return Card(
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
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

Widget employeeInfo(BuildContext context, title) {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
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
        radius: 20,
        backgroundColor: Colors.blue.shade100,
        child: Icon(icon, size: 20, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
