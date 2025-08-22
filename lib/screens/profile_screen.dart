import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/screens/profile_edit_screen.dart';
import 'package:hr_attendance_tracker/widgets/app_version.dart';
import 'package:provider/provider.dart';

const String employeeId = "9901";
const String employeeType = "Trainee";
const String dateOfJoin = "3 February 2025";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>().profiles;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 16.0,
            ),
            children: [
              profileHeader(context, profileProvider),
              const SizedBox(height: 16),
              contactInfo(context, profileProvider),
              const SizedBox(height: 16),
              employeeInfo(context),
            ],
          ),
        ),
        AppVersion(),
      ],
    );
  }
}

Widget profileHeader(BuildContext context, provider) {
  final today = DateTime.now();
  final date =
      "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}";

  return Column(
    children: [
      Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
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
            top: 5,
            right: 20,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileEditScreen()),
                );
              },
              icon: Icon(Icons.edit, color: Colors.blue),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipOval(
                child: provider.profileImage != null
                    ? Image.file(
                        provider.profileImage!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/img/profile.jpg",
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
      Text(provider.fullName, style: Theme.of(context).textTheme.headlineLarge),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            provider.position,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            provider.department,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ],
  );
}

Widget contactInfo(BuildContext context, provider) {
  return Card(
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Information",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ProfileItem(
            title: 'Email',
            subtitle: provider.email,
            icon: Icons.email,
          ),
          ProfileItem(
            title: 'Phone',
            subtitle: provider.phone,
            icon: Icons.phone,
          ),
          ProfileItem(
            title: 'Location',
            subtitle: provider.location,
            icon: Icons.location_on,
          ),
        ],
      ),
    ),
  );
}

Widget employeeInfo(BuildContext context) {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Employee Information",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
