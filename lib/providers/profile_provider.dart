import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  Profile _profiles = Profile(
    fullName: "Kunto Wicaksono",
    position: "Software Engineer",
    department: "Mobile Development",
    email: "kunto@solecode.id",
    phone: "+62 812-3456-7890",
    location: "Jakarta, Indonesia",
    profileImage: null,
  );

  Profile get profiles => _profiles;

  late TextEditingController fullNameController;
  late TextEditingController positionController;
  late TextEditingController departmentController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  late String _backupFullName;
  late String _backupPosition;
  late String _backupDepartment;
  late String _backupEmail;
  late String _backupPhone;
  late String _backupLocation;

  File? profileImage;

  ProfileProvider() {
    fullNameController = TextEditingController(text: profiles.fullName);
    positionController = TextEditingController(text: profiles.position);
    departmentController = TextEditingController(text: profiles.department);
    emailController = TextEditingController(text: profiles.email);
    phoneController = TextEditingController(text: profiles.phone);
    locationController = TextEditingController(text: profiles.location);

    _backupProfile();
  }

  void _backupProfile() {
    _backupFullName = fullNameController.text;
    _backupPosition = positionController.text;
    _backupDepartment = departmentController.text;
    _backupEmail = emailController.text;
    _backupPhone = phoneController.text;
    _backupLocation = locationController.text;
  }

  void discardChanges() {
    fullNameController.text = _backupFullName;
    positionController.text = _backupPosition;
    departmentController.text = _backupDepartment;
    emailController.text = _backupEmail;
    phoneController.text = _backupPhone;
    locationController.text = _backupLocation;
  }

  void setImage(File? value) {
    if (value != null) {
      profileImage = value;
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
    }
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  Future<void> updateProfile() async {
    await Future.delayed(Duration(seconds: 2));

    _profiles = Profile(
      fullName: fullNameController.text,
      position: positionController.text,
      department: departmentController.text,
      email: emailController.text,
      phone: phoneController.text,
      location: locationController.text,
      profileImage: profileImage,
    );
    _backupProfile();

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
