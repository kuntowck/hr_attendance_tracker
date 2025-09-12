import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile_model.dart';
import 'package:hr_attendance_tracker/services/profile_service.dart';

class AdminProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final ProfileService _service = ProfileService();

  List<Profile> _employees = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Profile> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadEmployees() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _employees = await _service.getEmployees();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newEmployee = await _service.createEmployee(
        email: email,
        password: password,
        name: name,
      );
      _employees.add(newEmployee);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }
}
