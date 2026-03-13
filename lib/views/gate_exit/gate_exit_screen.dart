import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../controllers/workflow_controller.dart';

class GateExitScreen extends ConsumerStatefulWidget {
  const GateExitScreen({super.key});

  @override
  ConsumerState<GateExitScreen> createState() => _GateExitScreenState();
}

class _GateExitScreenState extends ConsumerState<GateExitScreen> {
  File? _passImage;
  Uint8List? _passWebBytes;
  
  File? _billImage;
  Uint8List? _billWebBytes;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isGatePass, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          if (!mounted) return;
          setState(() {
            if (isGatePass) {
              _passWebBytes = bytes;
              _passImage = null;
            } else {
              _billWebBytes = bytes;
              _billImage = null;
            }
          });
        } else {
          if (!mounted) return;
          setState(() {
            if (isGatePass) {
              _passImage = File(image.path);
              _passWebBytes = null;
            } else {
              _billImage = File(image.path);
              _billWebBytes = null;
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showSourceDialog(bool isGatePass) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${isGatePass ? 'Gate Pass' : 'Bill'} Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(isGatePass, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(isGatePass, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gate Exit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
            ),
            AppButton(
              text: 'Complete Workflow',
              icon: Icons.check_circle_outline,
              onPressed: () {
                ref.read(workflowControllerProvider.notifier).nextStep();
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Gate Pass & Billing',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Divider(color: ColorPalette.secondaryColor),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildImageUpload(
                title: 'Gate Pass image',
                icon: Icons.badge_outlined,
                image: _passImage,
                webBytes: _passWebBytes,
                onTap: () => _showSourceDialog(true),
                onRemove: () => setState(() {
                  _passImage = null;
                  _passWebBytes = null;
                }),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildImageUpload(
                title: 'Bill Upload',
                icon: Icons.receipt_long_outlined,
                image: _billImage,
                webBytes: _billWebBytes,
                onTap: () => _showSourceDialog(false),
                onRemove: () => setState(() {
                  _billImage = null;
                  _billWebBytes = null;
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUpload({
    required String title,
    required IconData icon,
    required File? image,
    required Uint8List? webBytes,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    final bool hasImage = image != null || webBytes != null;

    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 200,
              width: 250,
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorPalette.borderColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    if (!hasImage)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: 40, color: ColorPalette.textSecondary),
                            const SizedBox(height: 12),
                            Text(
                              title,
                              style: const TextStyle(
                                color: ColorPalette.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: ColorPalette.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Upload',
                                style: TextStyle(
                                  color: ColorPalette.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (kIsWeb && webBytes != null)
                      Image.memory(
                        webBytes,
                        width: 250,
                        height: 200,
                        fit: BoxFit.fill,
                      )
                    else if (image != null)
                      Image.file(
                        image,
                        width: 250,
                        height: 200,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error_outline, color: Colors.red),
                          );
                        },
                      ),
                    if (hasImage)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: onRemove,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black54,
                            child: const Icon(
                              Icons.close, 
                              size: 18, 
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
