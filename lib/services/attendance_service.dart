import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hr_attendance_tracker/models/attendance_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  static const String baseUrl = "http://192.168.1.4:5144/api/attendance";
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch records from the API
  Future<List<AttendanceModel>> fetchAttendances(employeeId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl?employeeId=$employeeId"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);

        return json.map((data) => AttendanceModel.fromJson(data)).toList();
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request. Please check your input.");
      } else if (response.statusCode == 404) {
        throw Exception("Attendance logs is not found.");
      } else if (response.statusCode >= 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception(
          "Failed to load attendance logs: ${response.statusCode} | ${response.body}",
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      rethrow;
    }
  }

  //Add a new record
  Future<AttendanceModel> addAttendanceRecord(
    AttendanceModel attendance,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/checkin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(attendance.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return AttendanceModel.fromJson(data);
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request. Please check your input.");
      } else if (response.statusCode >= 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception(
          'Failed to add attendance log: ${response.statusCode} | ${response.body}',
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      rethrow;
    }
  }

  // Update record
  Future<void> updateAttendanceRecord(AttendanceModel attendance) async {
    try {
      final toJson = attendance.toJson();

      final response = await http.put(
        Uri.parse('$baseUrl/checkout/${attendance.id}'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(toJson),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          throw Exception("Validation error. Please check your input.");
        } else if (response.statusCode == 404) {
          throw Exception("Attendance logs is not found.");
        } else if (response.statusCode >= 500) {
          throw Exception("Server error. Please try again later.");
        } else {
          throw Exception(
            'Failed to update attendance log: ${response.statusCode} | ${response.body}',
          );
        }
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/uploads"),
      );

      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();

        final json = jsonDecode(responseData);

        return json['url']; // URL file dari server
      } else {
        throw Exception("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json",
        ),
        headers: {"User-Agent": "flutter_app"},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return json['display_name'];
      } else {
        throw Exception("Failed to get location: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadPhoto(String employeeId, File file) async {
    final String fileName = "$employeeId-${DateTime.now()}";

    await _supabase.storage
        .from('attendance-photos')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

    final url = _supabase.storage
        .from('attendance-photos')
        .getPublicUrl(fileName);

    return url;
  }
}
