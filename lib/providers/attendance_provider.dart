import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceModel? _attendanceRecord;
  final List<AttendanceModel> _attendanceHistory = [];
  bool _isCheckedIn = false;
  // DateFormat formatTime = DateFormat('HH:mm');

  AttendanceModel? get record => _attendanceRecord;
  List<AttendanceModel> get history => _attendanceHistory;
  bool get isCheckedIn => _isCheckedIn;
  String get formattedDate => DateFormat('EEEE, d MMM').format(DateTime.now());

  void checkIn() {
    _attendanceRecord = AttendanceModel(
      date: formattedDate,
      checkIn: DateTime.now(),
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
