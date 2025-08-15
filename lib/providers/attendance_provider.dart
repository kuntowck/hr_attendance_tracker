import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceModel? _attendanceRecord;
  final List<AttendanceModel> _attendanceHistory = [];
  bool _isCheckedIn = false;

  AttendanceModel? get record => _attendanceRecord;
  List<AttendanceModel> get history => _attendanceHistory;
  bool get isCheckedIn => _isCheckedIn;

  String formattedDate = DateFormat('EEEE, d MMM').format(DateTime.now());
  String formattedTime = DateFormat('HH:mm').format(DateTime.now());

  void checkIn() {
    _attendanceRecord = AttendanceModel(
      date: formattedDate,
      checkIn: DateFormat('HH:mm').format(DateTime.now()),
      checkOut: null,
      status: 'In Progress',
    );

    _isCheckedIn = true;

    notifyListeners();
  }

  void checkOut() {
    if (_attendanceRecord != null) {
      _attendanceRecord!.checkOut = DateFormat('HH:mm').format(DateTime.now());
      
      _attendanceRecord!.status = 'Present';

      _attendanceHistory.add(_attendanceRecord!);
      _attendanceRecord = null;
      _isCheckedIn = false;

      notifyListeners();
    }
  }
}
