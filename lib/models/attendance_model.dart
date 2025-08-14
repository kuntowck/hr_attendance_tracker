class AttendanceModel {
  DateTime date;
  DateTime checkIn;
  DateTime checkOut;
  String status;

  AttendanceModel({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });
}
