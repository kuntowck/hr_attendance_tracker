class AttendanceModel {
  int? id;
  int? employeeId;
  final DateTime date;
  DateTime? checkIn;
  DateTime? checkOut;
  String? status;
  Duration? duration;

  AttendanceModel({
    this.id,
    this.employeeId = 1,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.status,
    this.duration,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['id'],
      employeeId: data['employee_id'],
      date: DateTime.parse(data['date']).toLocal(),
      checkIn: data['check_in'] != null
          ? DateTime.parse(data['check_in']).toLocal()
          : null,
      checkOut: data['check_out'] != null
          ? DateTime.parse(data['check_out']).toLocal()
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
    "check_in": checkIn?.toIso8601String(),
    "check_out": checkOut?.toIso8601String(),
    "status": status,
    "duration": duration.toString(),
  };

  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;

    // Split by spaces to get parts like ["7", "hours", "45", "minutes"]
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
