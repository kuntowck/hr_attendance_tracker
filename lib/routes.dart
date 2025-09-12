import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/main.dart';
import 'package:hr_attendance_tracker/screens/about_screen.dart';
import 'package:hr_attendance_tracker/screens/admin/dashboard_screen.dart';
import 'package:hr_attendance_tracker/screens/admin/employee_add_screen.dart';
import 'package:hr_attendance_tracker/screens/attendance_history_screen.dart';
import 'package:hr_attendance_tracker/screens/login_screen.dart';
import 'package:hr_attendance_tracker/screens/not_found_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_edit_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:hr_attendance_tracker/screens/setting_.screen.dart';

class Routes {
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const profile = '/profile';
  static const editProfile = '/editProfile';
  static const attendanceHistory = '/attendanceHistory';
  static const about = '/about';
  static const setting = '/settings';
  static const adminDashboard = '/adminDashboard';
  static const addEmployee = '/addEmployee';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => MainScreen());
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
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => AdminDashboardScreen());
      case addEmployee:
        return MaterialPageRoute(builder: (_) => EmployeeAddScreen());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
