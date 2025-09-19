import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  final bool isCheckedin;
  const AttendanceScreen({super.key, required this.isCheckedin});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  void _submitAttendance() {
    final attendanceProvider = context.read<AttendanceProvider>();

    if (_capturedImage != null) {
      if (widget.isCheckedin) {
        attendanceProvider.checkIn(File(_capturedImage!.path));
      } else {
        attendanceProvider.checkOut(File(_capturedImage!.path));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();

    return Scaffold(
      body: SafeArea(
        child: _capturedImage == null
            ? FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Transform.scale(
                            scaleY: -1,
                            child: CameraPreview(_controller!),
                          ),
                        ),

                        Positioned(
                          top: 20,
                          left: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: _takePicture,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 6,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
            : Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 3 / 4, // potrait card
                              child: Image.file(
                                File(_capturedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 10,
                            left: 10,
                            // child: ElevatedButton.icon(
                            //   onPressed: () {
                            //     setState(() {
                            //       _capturedImage = null;
                            //     });
                            //   },
                            //   icon: const Icon(Icons.refresh),
                            //   label: const Text("Retake"),
                            // ),
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _capturedImage = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bagian bawah: location, time, submit
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attendance Information',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Log time: ',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                attendanceProvider.logTime,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            children: [
                              Text(
                                'Location: ',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                attendanceProvider.location ?? '-',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ), // child: CustomSubmitButtonDialog(
                            ],
                          ),
                          //   submitText: 'Check-out',
                          //   titleDialog: 'Confirm Check Out',
                          //   contentDialog: 'Are you sure want to chek-out now?',
                          //   confirmButtonDialogText: 'Yes, check-out',
                          //   validateForm: () => true,
                          //   onSubmitAsync: () => provider.checkOut(),
                          //   successMessage: 'Check-out succesfully.',
                          //   errorMessage: 'Check-out failed',
                          // ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: _submitAttendance,
                              child: Text(
                                widget.isCheckedin
                                    ? "Submit Check-in"
                                    : "Submit Check-out",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
