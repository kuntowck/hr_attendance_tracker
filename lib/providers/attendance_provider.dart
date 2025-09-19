import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/services/attendance_service.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance_tracker/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _service;
  final AuthProvider _authProvider;
  List<AttendanceModel> _attendanceHistory = [];
  AttendanceModel? _attendanceRecord;
  bool _isCheckedIn = false;

  AttendanceModel? get record => _attendanceRecord;
  List<AttendanceModel> get history => _attendanceHistory;
  String get formattedDate => DateFormat('EEEE, d MMM').format(DateTime.now());
  String get logTime => DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
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
  Position? _position;
  String? _location = '';
  String? _locationPermission = '';
  File? _checkinPhoto;
  File? _checkoutPhoto;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String? get location => _location;
  String? get locationPermission => _locationPermission;
  File? get checkinPhoto => _checkinPhoto;
  File? get checkoutPhoto => _checkoutPhoto;

  AttendanceProvider(this._authProvider, this._service);

  Future<void> loadAttendances() async {
    final user = _authProvider.user;
    _errorMessage = null;
    _isLoading = true;

    notifyListeners();
    try {
      _attendanceHistory = await _service.fetchAttendances(user!.uid);

      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> checkIn(File photo) async {
    final user = _authProvider.user;
    _errorMessage = null;

    notifyListeners();
    try {
      final now = DateTime.now();

      final photoUrl = await _service.uploadPhoto(user!.uid, photo);

      _attendanceRecord = await _service.addAttendanceRecord(
        AttendanceModel(
          employeeId: user.uid,
          date: now,
          checkin: now,
          status: 'In Progress',
          checkinPhotoUrl: photoUrl,
          checkinLatitude: _position!.latitude,
          checkinLongitude: _position!.longitude,
        ),
      );

      loadAttendances();

      _isCheckedIn = true;
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<void> checkOut(File photo) async {
    final user = _authProvider.user;
    _errorMessage = null;

    notifyListeners();
    try {
      if (_attendanceRecord != null) {
        final now = DateTime.now();

        DateTime adjustedCheckOut = now;

        // jika lewat hari berikutnya
        if (_attendanceRecord != null &&
            _attendanceRecord!.checkin != null &&
            adjustedCheckOut.isBefore(_attendanceRecord!.checkin!)) {
          adjustedCheckOut = adjustedCheckOut.add(Duration(days: 1));
        }

        final duration = adjustedCheckOut.difference(
          _attendanceRecord!.checkin ?? adjustedCheckOut,
        );

        await getLocation();

        final photoUrl = await _service.uploadPhoto(user!.uid, photo);

        await _service.updateAttendanceRecord(
          _attendanceRecord!.copyWith(
            checkout: now,
            checkoutPhotoUrl: photoUrl,
            checkoutLatitude: _position!.latitude,
            checkoutLongitude: _position!.longitude,
            status: 'Present',
            duration: duration,
          ),
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

  Future<void> _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      _locationPermission = "Location services are disabled.";

      notifyListeners();

      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _locationPermission = "Location permission denied.";

        notifyListeners();

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _locationPermission = "Location permission permanently denied.";

      notifyListeners();

      return;
    }

    _locationPermission = "Location permission granted ✅";

    notifyListeners();
  }

  Future<void> getLocation() async {
    _errorMessage = null;
    _isLoading = true;

    notifyListeners();
    try {
      await _checkPermission();

      _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _location = await _service.getAddressFromLatLng(
        _position!.latitude,
        _position!.longitude,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = true;

      notifyListeners();
    }
  }

  void setPhoto(File photo) {
    _checkinPhoto = photo;

    notifyListeners();
  }
}
