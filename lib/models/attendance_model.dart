class AttendanceModel {
  final DateTime date;
  DateTime? checkIn;
  DateTime? checkOut;
  String? status;
  Duration? duration;

  AttendanceModel({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.status,
    this.duration,
  });

  // @override
  // String toString() {
  //   return 'Attendance(date: $date, checkin: $checkIn, checkout: $checkOut, status: $status)';
  // }
}
