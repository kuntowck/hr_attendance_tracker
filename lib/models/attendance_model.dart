class AttendanceModel {
  String date;
  String checkIn;
  String? checkOut;
  String? status;

  AttendanceModel({
    required this.date,
    required this.checkIn,
    this.checkOut,
    this.status,
  });

  @override
  String toString() {
    return 'Attendance(date: $date, checkin: $checkIn, checkout: $checkOut, status: $status)';
  }
}
