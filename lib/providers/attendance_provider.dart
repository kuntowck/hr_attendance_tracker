import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/services/attendance_service.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();
  List<AttendanceModel> _attendanceHistory = [];
  AttendanceModel? _attendanceRecord;
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

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> loadAttendances() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceHistory = await _service.fetchAttendances();

      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkIn() async {
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();

      _attendanceRecord = await _service.addAttendanceRecord(
        AttendanceModel(date: now, checkIn: now, status: 'In Progress'),
      );
      loadAttendances();

      _isCheckedIn = true;
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<void> checkOut() async {
    _errorMessage = null;
    notifyListeners();

    try {
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

        await _service.updateAttendanceRecord(
          _attendanceRecord!
            ..checkOut = now
            ..status = 'Present'
            ..duration = duration,
        );

        _attendanceHistory.add(_attendanceRecord!);
        loadAttendances();

        _attendanceRecord = null;
        _isCheckedIn = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}
