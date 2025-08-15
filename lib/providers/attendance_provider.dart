import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceModel? _attendanceRecord;
  final List<AttendanceModel> _attendanceHistory = [];
  bool _isCheckedIn = false;

  AttendanceModel? get record => _attendanceRecord;
  List<AttendanceModel> get history => _attendanceHistory;
  String get formattedDate => DateFormat('EEEE, d MMM').format(DateTime.now());
  bool get isCheckedIn => _isCheckedIn;
  bool get isCheckedInToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    bool alreadyCheckedInToday = _attendanceHistory.any(
      (history) =>
          history.date.year == today.year &&
          history.date.month == today.month &&
          history.date.day == today.day,
    );

    return alreadyCheckedInToday;
  }

  void checkIn() {
    final now = DateTime.now();

    _attendanceRecord = AttendanceModel(
      date: now,
      checkIn: now,
      status: 'In Progress',
    );

    _isCheckedIn = true;

    notifyListeners();
  }

  void checkOut() {
    if (_attendanceRecord != null) {
      final now = DateTime.now();

      DateTime adjustedCheckOut = now;
      if (adjustedCheckOut.isBefore(_attendanceRecord!.checkIn)) {
        adjustedCheckOut = adjustedCheckOut.add(Duration(days: 1));
      }

      final duration = adjustedCheckOut.difference(_attendanceRecord!.checkIn);

      _attendanceRecord!
        ..checkOut = now
        ..status = 'Present'
        ..duration = duration;

      _attendanceHistory.add(_attendanceRecord!);
      _attendanceRecord = null;
      _isCheckedIn = false;

      notifyListeners();
    }
  }
}
