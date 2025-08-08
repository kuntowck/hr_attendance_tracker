import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/screens/attendance_history_screen.dart';
import 'package:hr_attendance_tracker/screens/employee_profile_screen.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/widgets/custom_buttom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Attendance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // warna dasar
        ),
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ralewayTextTheme().copyWith(
          headlineLarge: GoogleFonts.raleway(fontWeight: FontWeight.bold),
          headlineSmall: GoogleFonts.raleway(fontWeight: FontWeight.w600),
          labelLarge: GoogleFonts.raleway(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: GoogleFonts.raleway(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  final List<Widget> _screens = [
    HomeScreen(),
    AttendanceHistoryScreen(),
    EmployeeProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AttendanceHistoryScreen()),
          );
        },
        tooltip: 'Attendance History',
        child: Icon(Icons.contact_mail),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
