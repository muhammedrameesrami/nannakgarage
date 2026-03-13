import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import '../../common/widgets/web_camera_dialog.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/workflow_controller.dart';

class GateEntryScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSubmit;

  const GateEntryScreen({super.key, this.onSubmit});

  @override
  ConsumerState<GateEntryScreen> createState() => _GateEntryScreenState();
}

class _GateEntryScreenState extends ConsumerState<GateEntryScreen> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _kmDrivenController = TextEditingController();

  File? _pickedImage;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedBookingId;

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _vehicleNumberController.dispose();
    _kmDrivenController.dispose();
    super.dispose();
  }

  void _onBookingSelected(String? bookingId) {
    if (bookingId == null) return;

    final bookings = ref.read(bookingControllerProvider).bookings;
    final selectedBooking = bookings.firstWhere((b) => b.id == bookingId);

    setState(() {
      _selectedBookingId = bookingId;
      _customerNameController.text = selectedBooking.customer.name;
      _customerPhoneController.text = selectedBooking.customer.phone;
      _vehicleNumberController.text = selectedBooking.vehicle.number;
      _kmDrivenController.text = selectedBooking.vehicle.kmDriven;
      _selectedBrand = selectedBooking.vehicle.brand;
      _selectedModel = selectedBooking.vehicle.model;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (kIsWeb && source == ImageSource.camera) {
        // Use custom camera dialog for Web
        final Uint8List? imageBytes = await showDialog<Uint8List>(
          context: context,
          builder: (context) => const WebCameraDialog(),
        );

        if (imageBytes != null) {
          if (!mounted) return;
          setState(() {
            _webImageBytes = imageBytes;
            _pickedImage = null;
          });
        }
        return;
      }

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
            _webImageBytes = bytes;
            _pickedImage = null; // Clear file-based image if any
          });
        } else {
          if (!mounted) return;
          setState(() {
            _pickedImage = File(image.path);
            _webImageBytes = null; // Clear web-based image if any
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(workflowControllerProvider.notifier);
    final bookingState = ref.watch(bookingControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter Gate Entry',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AppDropdown<String>(
          label: 'Select Booking (Optional)',
          hint: 'Select to auto-populate',
          value: _selectedBookingId,
          items: bookingState.bookings
              .map(
                (b) => DropdownMenuItem(
                  value: b.id,
                  child: Text('${b.vehicle.number} - ${b.customer.name}'),
                ),
              )
              .toList(),
          onChanged: _onBookingSelected,
        ),
        const SizedBox(height: 24),
        Center(
          child: InkWell(
            onTap: _showImageSourceDialog,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 200,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: ColorPalette.borderColor),
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.backgroundColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    if (_pickedImage == null && _webImageBytes == null)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 32,
                              color: ColorPalette.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Upload Number Plate',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorPalette.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (kIsWeb && _webImageBytes != null)
                      Image.memory(
                        _webImageBytes!,
                        width: 250,
                        height: 200,
                        fit: BoxFit.fill,
                      )
                    else if (_pickedImage != null)
                      Image.file(
                        _pickedImage!,
                        width: 250,
                        height: 200,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error_outline, color: Colors.red),
                          );
                        },
                      ),
                    if (_pickedImage != null || _webImageBytes != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => setState(() {
                            _pickedImage = null;
                            _webImageBytes = null;
                          }),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black54,
                            child: const Icon(
                              Icons.close,
                              size: 16,
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
        const SizedBox(height: 32),
        const Text(
          'Customer Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Divider(color: ColorPalette.secondaryColor),
        SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Customer Name',
                hint: 'John Doe',
                controller: _customerNameController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppTextField(
                label: 'Customer Phone',
                hint: '+1 987 654 3210',
                keyboardType: TextInputType.phone,
                controller: _customerPhoneController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Vehicle Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Divider(color: ColorPalette.secondaryColor),
        SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                label: 'Brand',
                hint: 'Toyota',
                value: _selectedBrand,
                items:
                    [
                      'Toyota',
                      'Honda',
                      'Nissan',
                      if (_selectedBrand != null &&
                          ![
                            'Toyota',
                            'Honda',
                            'Nissan',
                          ].contains(_selectedBrand))
                        _selectedBrand!,
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedBrand = val),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppDropdown<String>(
                label: 'Model',
                hint: 'RAV4',
                value: _selectedModel,
                items:
                    [
                      'RAV4',
                      'CR-V',
                      'Altima',
                      if (_selectedModel != null &&
                          !['RAV4', 'CR-V', 'Altima'].contains(_selectedModel))
                        _selectedModel!,
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedModel = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Vehicle Number',
                hint: 'KDB 654P',
                controller: _vehicleNumberController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppTextField(
                label: 'KM Driven',
                hint: '75,500 km',
                controller: _kmDrivenController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const SizedBox(height: 24),
        SizedBox(height: 24),
        Center(
          child: AppButton(
            text: 'Add Vehicle',
            onPressed: () {
              // Validations and next
              if (widget.onSubmit != null) {
                widget.onSubmit!();
              } else {
                notifier.nextStep();
              }
            },
          ),
        ),
      ],
    );
  }
}
