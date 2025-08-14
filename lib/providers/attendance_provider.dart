import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final List<AttendanceModel> _records = [];

  List<AttendanceModel> get records => _records;

  void addRecord(AttendanceModel attendance) {
    _records.add(attendance);
    notifyListeners();
  }

  void updateRecord(int index, AttendanceModel attendance) {
    _records[index] = attendance;
    notifyListeners();
  }
}
