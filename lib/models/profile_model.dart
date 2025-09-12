class Profile {
  final String employeeId;
  final String name;
  final String email;
  final String role;
  final String? profilePhoto;
  final String? position;
  final String? department;
  final String? phone;
  final String? location;

  Profile({
    required this.employeeId,
    required this.email,
    required this.name,
    required this.role,
    this.profilePhoto,
    this.position,
    this.department,
    this.phone,
    this.location,
  });

  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      employeeId: data['employeeId'],
      email: data['email'],
      name: data['name'],
      role: data['role'] ?? 'member',
      profilePhoto: data['photo'],
      position: data['position'],
      department: data['department'],
      phone: data['phone'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'email': email,
      'name': name,
      'role': role,
      'photo': profilePhoto,
      'position': position,
      'department': department,
      'phone': phone,
      'location': location,
    };
  }

  Profile copyWith({
    String? name,
    String? email,
    String? role,
    String? profilePhoto,
    String? position,
    String? department,
    String? phone,
    String? location,
  }) {
    return Profile(
      employeeId: employeeId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      position: position ?? this.position,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }
}
