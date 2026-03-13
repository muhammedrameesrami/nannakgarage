import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class WebCameraDialog extends StatefulWidget {
  const WebCameraDialog({super.key});

  @override
  State<WebCameraDialog> createState() => _WebCameraDialogState();
}

class _WebCameraDialogState extends State<WebCameraDialog> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Capture Image'),
      content:
          SizedBox(
            width: 400,
            height: 400,
            child:
                !_isInitialized
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        Expanded(child: CameraPreview(_controller!)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final XFile file =
                                    await _controller!.takePicture();
                                final bytes = await file.readAsBytes();
                                if (context.mounted) {
                                  Navigator.pop(context, bytes);
                                }
                              },
                              child: const Text('Capture'),
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
    );
  }
}
