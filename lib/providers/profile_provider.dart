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
  );

  Profile get profiles => _profiles;

  late TextEditingController fullNameController;
  late TextEditingController positionController;
  late TextEditingController departmentController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  File? profileImage;

  ProfileProvider() {
    fullNameController = TextEditingController(text: profiles.fullName);
    positionController = TextEditingController(text: profiles.position);
    departmentController = TextEditingController(text: profiles.department);
    emailController = TextEditingController(text: profiles.email);
    phoneController = TextEditingController(text: profiles.phone);
    locationController = TextEditingController(text: profiles.location);
  }

  void setImage(File? value) {
    if (value != null) {
      profileImage = value;
      print(profileImage);
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

  void updateProfile() {
    _profiles = Profile(
      fullName: fullNameController.text,
      position: positionController.text,
      department: departmentController.text,
      email: emailController.text,
      phone: phoneController.text,
      location: locationController.text,
      profileImage: profileImage!,
    );
    notifyListeners();
  }

  void resetForm() {
    fullNameController.clear();
    positionController.clear();
    departmentController.clear();
    emailController.clear();
    phoneController.clear();
    locationController.clear();
    profileImage = null;
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
