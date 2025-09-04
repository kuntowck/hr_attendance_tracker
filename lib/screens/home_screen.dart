import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile_model.dart';
import 'package:hr_attendance_tracker/providers/attendance_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/widgets/app_version.dart';
import 'package:hr_attendance_tracker/widgets/attendance_status.dart';
import 'package:hr_attendance_tracker/widgets/carousel.dart';
import 'package:hr_attendance_tracker/widgets/custom_submit_button_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final profileProvider = context.read<ProfileProvider>().profiles;

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
                  child: profileProvider.profileImage != null
                      ? Image.file(
                          profileProvider.profileImage!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/img/profile.jpg",
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: profileProvider.profileImage != null
                            ? Image.file(
                                profileProvider.profileImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/img/profile.jpg",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        profileProvider.fullName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
            "Hello, ${provider.fullName} 👋🏼",
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
                        provider.record?.checkIn != null
                            ? DateFormat(
                                'HH:mm',
                              ).format(provider.record!.checkIn!)
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
                            provider.checkIn();
                          },
                    child: Text('Check-in'),
                  ),
                ),
                const SizedBox(width: 8),
                if (provider.record != null) ...[
                  Expanded(
                    child: CustomSubmitButtonDialog(
                      submitText: 'Check-out',
                      titleDialog: 'Confirm Check Out',
                      contentDialog: 'Are you sure want to chek-out now?',
                      confirmButtonDialogText: 'Yes, check-out',
                      validateForm: () => true,
                      onSubmitAsync: () => provider.checkOut(),
                      successMessage: 'Check-in succesfully.',
                      errorMessage: 'Check-in failed',
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
