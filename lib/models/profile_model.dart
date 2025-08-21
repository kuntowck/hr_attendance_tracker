import 'dart:io';

class Profile {
  String fullName;
  String position;
  String department;
  File? profileImage;
  String email;
  String phone;
  String location;

  Profile({
    required this.fullName,
    required this.position,
    required this.department,
    this.profileImage,
    required this.email,
    required this.phone,
    required this.location,
  });
}
