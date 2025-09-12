import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile_model.dart';
import 'package:hr_attendance_tracker/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final ProfileService _profileService = ProfileService();

  // Profile _profiles = Profile(
  //   employeeId: '123',
  //   email: "kunto@solecode.id",
  //   name: "Kunto Wicaksono",
  //   role: 'admin',
  //   position: "Software Engineer",
  //   department: "Mobile Development",
  //   phone: "+62 812-3456-7890",
  //   location: "Jakarta, Indonesia",
  //   profilePhoto: null,
  // );

  Profile? _profile;
  bool _isLoading = false;

  String? profileImage;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final roleController = TextEditingController();
  final positionController = TextEditingController();
  final departmentController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  late String _backupEmail;
  late String _backupFullName;
  late String _backupRole;
  late String _backupPosition;
  late String _backupDepartment;
  late String _backupPhone;
  late String _backupLocation;

  Future<void> loadProfile(String employeeId) async {
    _setLoading(true);

    try {
      _profile = await _profileService.getUserProfile(employeeId);
      fullNameController.text = profile!.name;
      emailController.text = profile!.email;
      positionController.text = profile!.position ?? '';
      departmentController.text = profile!.department ?? '';
      phoneController.text = profile!.phone ?? '';
      locationController.text = profile!.location ?? '';

      _backupProfile();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile() async {
    if (_profile == null) return;

    if (!formKey.currentState!.validate()) return;

    _setLoading(true);

    try {
      final profileUpdated = Profile(
        employeeId: _profile!.employeeId,
        email: emailController.text,
        name: fullNameController.text,
        role: _profile!.role,
        profilePhoto: _profile!.profilePhoto ?? '',
        position: positionController.text,
        department: departmentController.text,
        phone: phoneController.text,
        location: locationController.text,
      );

      await _profileService.updateUserProfile(profileUpdated);

      _profile = profileUpdated;

      _backupProfile();

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> uploadProfilePhoto(File file) async {
    if (_profile == null) return;

    _setLoading(true);

    notifyListeners();

    try {
      final url = await _profileService.uploadProfilePhoto(
        _profile!.employeeId,
        file,
      );
      final updatedProfile = _profile!.copyWith(profilePhoto: url);

      await _profileService.updateUserProfile(updatedProfile);

      _profile = updatedProfile;

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      uploadProfilePhoto(File(pickedFile.path));
    }
  }

  void _backupProfile() {
    _backupEmail = emailController.text;
    _backupFullName = fullNameController.text;
    _backupRole = roleController.text;
    _backupPosition = positionController.text;
    _backupDepartment = departmentController.text;
    _backupPhone = phoneController.text;
    _backupLocation = locationController.text;
  }

  void discardChanges() {
    emailController.text = _backupEmail;
    fullNameController.text = _backupFullName;
    emailController.text = _backupRole;
    positionController.text = _backupPosition;
    departmentController.text = _backupDepartment;
    phoneController.text = _backupPhone;
    locationController.text = _backupLocation;
  }

  void setImage(String? value) {
    if (value != null) {
      profileImage = value;
    }
    notifyListeners();
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  void _setLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    positionController.dispose();
    departmentController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
