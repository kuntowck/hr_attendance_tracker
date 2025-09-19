import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hr_attendance_tracker/providers/attendance_provider.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/attendance_model.dart';

class AttendanceDetailScreen extends StatelessWidget {
  final AttendanceModel attendance;

  const AttendanceDetailScreen({super.key, required this.attendance});

  String formatDateTime(DateTime? dt) {
    if (dt == null) return "-";
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.read<AttendanceProvider>();
    final markers = <Marker>[];

    if (attendance.checkinLatitude != null &&
        attendance.checkinLongitude != null) {
      markers.add(
        Marker(
          point: LatLng(
            attendance.checkinLatitude!,
            attendance.checkinLongitude!,
          ),
          width: 60,
          height: 60,
          child: attendance.checkinPhotoUrl != null
              ? ClipOval(
                  child: Image.network(
                    attendance.checkinPhotoUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.login, size: 40, color: Colors.green),
          // child: Text('checkin'),
        ),
      );
    }

    if (attendance.checkoutLatitude != null &&
        attendance.checkoutLongitude != null) {
      markers.add(
        Marker(
          point: LatLng(
            attendance.checkoutLatitude!,
            attendance.checkoutLongitude!,
          ),
          width: 60,
          height: 60,
          child: attendance.checkoutPhotoUrl != null
              ? ClipOval(
                  child: Image.network(
                    attendance.checkoutPhotoUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.logout, size: 40, color: Colors.red),
        ),
      );
    }

    // fallback center map → checkin dulu, kalau kosong baru checkout
    final initialCenter = markers.isNotEmpty
        ? markers.first.point
        : LatLng(0, 0);

    print("Detail Scren: ${attendance.checkoutLatitude}");
    print("Detail Scren: ${attendance.checkinLongitude}");

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Detail")),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  // urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=o9nSJynSFIeV9QVXQsul',
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.hr_attendance_tracker',
                ),
                MarkerLayer(markers: markers),
                // MarkerLayer(
                //   markers: [
                //     Marker(
                //       point: LatLng(
                //         attendance.checkinLatitude!,
                //         attendance.checkinLongitude!,
                //       ),
                //       width: 60,
                //       height: 60,
                //       child: attendance.checkinPhotoUrl != null
                //           ? ClipOval(
                //               child: Image.network(
                //                 attendance.checkinPhotoUrl!,
                //                 fit: BoxFit.cover,
                //               ),
                //             )
                //           : const Icon(
                //               Icons.login,
                //               size: 40,
                //               color: Colors.green,
                //             ),
                //     ),
                //     Marker(
                //       point: LatLng(
                //         attendance.checkoutLatitude!,
                //         attendance.checkoutLongitude!,
                //       ),
                //       width: 60,
                //       height: 60,
                //       child: const Icon(
                //               Icons.logout,
                //               size: 40,
                //               color: Colors.red,
                //             ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.45,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black26,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, d MMM').format(attendance.date),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDetailCard(
                      context,
                      title: "Check-in",
                      value: formatDateTime(attendance.checkin),
                      icon: Icons.login,
                    ),
                    _buildDetailCard(
                      context,
                      title: "Check-out",
                      value: formatDateTime(attendance.checkout),
                      icon: Icons.logout,
                    ),
                    _buildDetailCard(
                      context,
                      title: "Duration",
                      value:
                          " ${attendance.duration != null ? '${attendance.duration!.inHours} jam ${attendance.duration!.inMinutes.remainder(60)} menit' : '-'}",
                      icon: Icons.timelapse,
                    ),
                    _buildDetailCard(
                      context,
                      title: "Status",
                      value: attendance.status ?? "-",
                      icon: Icons.info_outline,
                    ),
                    _buildDetailCard(
                      context,
                      title: "Location",
                      value: attendanceProvider.location!,
                      icon: Icons.calendar_today,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surfaceBright,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
