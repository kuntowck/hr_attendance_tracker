import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/screens/about_screen.dart';
import 'package:hr_attendance_tracker/screens/attendance_history_screen.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/screens/not_found_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_edit_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:hr_attendance_tracker/screens/setting_.screen.dart';

class Routes {
  static const home = '/home';
  static const profile = '/profile';
  static const editProfile = '/editProfile';
  static const attendanceHistory = '/attendanceHistory';
  static const about = '/about';
  static const setting = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => ProfileEditScreen());
      case attendanceHistory:
        return MaterialPageRoute(builder: (_) => AttendanceHistoryScreen());
      case about:
        return MaterialPageRoute(builder: (_) => AboutScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
