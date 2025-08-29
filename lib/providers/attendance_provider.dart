import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final List<AttendanceModel> _attendanceHistory = [];
  AttendanceModel? _attendanceRecord;
  bool _isCheckedIn = false;
  final List<AttendanceModel> dummyRecords = List.generate(7, (i) {
    final date = DateTime.now().subtract(Duration(days: i + 1));

    if (i == 2) {
      return AttendanceModel(
        date: date,
        checkIn: DateTime(date.year, date.month, date.day, 8),
        status: 'Missed',
      );
    }
    if (i == 5) {
      return AttendanceModel(date: date, checkOut: null, status: 'Missed');
    }

    return AttendanceModel(
      date: date,
      checkIn: DateTime(date.year, date.month, date.day, 8),
      checkOut: DateTime(date.year, date.month, date.day, 17),
      status: 'Present',
      duration: Duration(hours: 8),
    );
  });

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

  List<AttendanceModel> get mergedRecords =>
      [..._attendanceHistory, ...dummyRecords]
        ..sort((a, b) => a.date.compareTo(b.date));

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

      // jika lewat hari berikutnya
      if (_attendanceRecord != null &&
          _attendanceRecord!.checkIn != null &&
          adjustedCheckOut.isBefore(_attendanceRecord!.checkIn!)) {
        adjustedCheckOut = adjustedCheckOut.add(Duration(days: 1));
      }

      final duration = adjustedCheckOut.difference(
        _attendanceRecord!.checkIn ?? adjustedCheckOut,
      );

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
