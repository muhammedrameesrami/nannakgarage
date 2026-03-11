import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/color_palette.dart';

class VideoUploadWidget extends StatefulWidget {
  final String label;
  final Function(File?) onVideoSelected;

  const VideoUploadWidget({
    Key? key,
    required this.label,
    required this.onVideoSelected,
  }) : super(key: key);

  @override
  State<VideoUploadWidget> createState() => _VideoUploadWidgetState();
}

class _VideoUploadWidgetState extends State<VideoUploadWidget> {
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
      widget.onVideoSelected(_videoFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: ColorPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickVideo,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _videoFile != null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library,
                            color: ColorPalette.primaryColor,
                            size: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Video Selected',
                            style: TextStyle(
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam,
                          color: ColorPalette.textSecondary,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap to upload video',
                          style: TextStyle(color: ColorPalette.textSecondary),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
