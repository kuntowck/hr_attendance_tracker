class AttendanceModel {
  final int? id;
  final String employeeId;
  final DateTime date;

  final DateTime? checkin;
  final String? checkinPhotoUrl;
  final double? checkinLatitude;
  final double? checkinLongitude;

  final DateTime? checkout;
  final String? checkoutPhotoUrl;
  final double? checkoutLatitude;
  final double? checkoutLongitude;

  final String? status;
  final Duration? duration;

  AttendanceModel({
    this.id,
    required this.employeeId,
    required this.date,
    this.checkin,
    this.checkinPhotoUrl,
    this.checkinLatitude,
    this.checkinLongitude,
    this.checkout,
    this.checkoutPhotoUrl,
    this.checkoutLatitude,
    this.checkoutLongitude,
    this.status,
    this.duration,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['id'],
      employeeId: data['employee_id'],
      date: DateTime.parse(data['date']).toLocal(),
      checkin: data['check_in'] != null
          ? DateTime.parse(data['check_in']).toLocal()
          : null,
      checkinPhotoUrl: data['checkin_photo_url'],

      checkinLatitude: data['checkin_latitude'] != null
          ? double.tryParse(data['checkin_latitude'].toString())
          : null,
      checkinLongitude: data['checkin_longitude'] != null
          ? double.tryParse(data['checkin_longitude'].toString())
          : null,
      checkout: data['check_out'] != null
          ? DateTime.parse(data['check_out']).toLocal()
          : null,
      checkoutPhotoUrl: data['checkout_photo_url'],
      checkoutLatitude: data['checkout_latitude'] != null
          ? double.tryParse(data['checkout_latitude'].toString())
          : null,
      checkoutLongitude: data['checkout_longitude'] != null
          ? double.tryParse(data['checkout_longitude'].toString())
          : null,
      status: data['status'],
      duration: data['duration'] != null
          ? parseDuration(data['duration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "employee_id": employeeId,
    "date": date.toIso8601String(),
    "check_in": checkin?.toIso8601String(),
    'checkin_photo_url': checkinPhotoUrl,
    'checkin_latitude': checkinLatitude,
    'checkin_longitude': checkinLongitude,
    "check_out": checkout?.toIso8601String(),
    'checkout_photo_url': checkoutPhotoUrl,
    'checkout_latitude': checkoutLatitude,
    'checkout_longitude': checkoutLongitude,
    "status": status,
    "duration": duration.toString(),
  };

  AttendanceModel copyWith({
    int? id,
    String? employeeId,
    DateTime? date,
    DateTime? checkin,
    String? checkinPhotoUrl,
    double? checkinLatitude,
    double? checkinLongitude,
    DateTime? checkout,
    String? checkoutPhotoUrl,
    double? checkoutLatitude,
    double? checkoutLongitude,
    String? status,
    Duration? duration,
  }) {
    return AttendanceModel(
      id: this.id,
      employeeId: this.employeeId,
      date: this.date,
      checkin: this.checkin,
      checkinPhotoUrl: this.checkinPhotoUrl,
      checkinLatitude: this.checkinLatitude,
      checkinLongitude: this.checkinLongitude,
      checkout: checkout ?? this.checkout,
      checkoutPhotoUrl: checkoutPhotoUrl ?? this.checkoutPhotoUrl,
      checkoutLatitude: checkoutLatitude ?? this.checkoutLatitude,
      checkoutLongitude: checkoutLongitude ?? this.checkoutLongitude,
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }

  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;

    List<String> parts = s.toLowerCase().split(' ');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i] == 'hours' || parts[i] == 'hour') {
        hours = int.parse(parts[i - 1]);
      }
      if (parts[i] == 'minutes' || parts[i] == 'minute') {
        minutes = int.parse(parts[i - 1]);
      }
    }

    return Duration(hours: hours, minutes: minutes);
  }
}
