import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile_model.dart';
import 'package:hr_attendance_tracker/providers/attendance_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/widgets/app_version.dart';
import 'package:hr_attendance_tracker/widgets/attendance_status.dart';
import 'package:hr_attendance_tracker/widgets/carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final profileProvider = context.read<ProfileProvider>().profile;
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer(); // buka drawer manual
              },
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary, // border pakai warna theme
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child:
                      profileProvider!.profilePhoto != null &&
                          profileProvider.profilePhoto!.isNotEmpty
                      ? Image.network(
                          profileProvider.profilePhoto!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/img/logo-noimage.png",
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child:
                            profileProvider!.profilePhoto != null &&
                                profileProvider.profilePhoto!.isNotEmpty
                            ? Image.network(
                                profileProvider.profilePhoto!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/img/logo-noimage.png",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        profileProvider.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('About'),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.about);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.setting);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                label: Text('Sign Out'),
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await authProvider.signOut();

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  welcomeHeader(context, profileProvider),
                  const SizedBox(height: 8),
                  appInfoCard(context, "About This App"),
                  const SizedBox(height: 8),
                  attendanceRecord(context, attendanceProvider),
                  const SizedBox(height: 8),
                  Carousel(),
                ],
              ),
            ),
            AppVersion(),
          ],
        ),
      ),
    );
  }

  Widget welcomeHeader(BuildContext context, Profile provider) {
    return Container(
      // height: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, ${provider.name} 👋🏼",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

  Widget attendanceRecord(BuildContext context, AttendanceProvider provider) {
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
              style: Theme.of(context).textTheme.headlineSmall,
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
                        provider.record?.checkin != null
                            ? DateFormat(
                                'HH:mm',
                              ).format(provider.record!.checkin!)
                            : '-',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  AttendanceStatus(status: provider.record?.status ?? ''),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.isCheckedIn || provider.isCheckedInToday
                        ? null
                        : () {
                            provider.getLocation();

                            Navigator.pushNamed(
                              context,
                              Routes.attendance,
                              arguments: true,
                            );
                          },
                    child: Text('Check-in'),
                  ),
                ),
                const SizedBox(width: 8),
                if (provider.record != null) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        Routes.attendance,
                        arguments: false,
                      ),
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
