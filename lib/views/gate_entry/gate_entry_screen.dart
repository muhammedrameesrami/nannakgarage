import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/workflow_controller.dart';

class GateEntryScreen extends ConsumerStatefulWidget {
  const GateEntryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GateEntryScreen> createState() => _GateEntryScreenState();
}

class _GateEntryScreenState extends ConsumerState<GateEntryScreen> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _kmDrivenController = TextEditingController();
  
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
              .map((b) => DropdownMenuItem(
                    value: b.id,
                    child: Text('${b.vehicle.number} - ${b.customer.name}'),
                  ))
              .toList(),
          onChanged: _onBookingSelected,
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
                items: const [
                  DropdownMenuItem(value: 'Toyota', child: Text('Toyota')),
                  DropdownMenuItem(value: 'Honda', child: Text('Honda')),
                  DropdownMenuItem(value: 'Nissan', child: Text('Nissan')),
                ],
                onChanged: (val) => setState(() => _selectedBrand = val),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppDropdown<String>(
                label: 'Model',
                hint: 'RAV4',
                value: _selectedModel,
                items: const [
                  DropdownMenuItem(value: 'RAV4', child: Text('RAV4')),
                  DropdownMenuItem(value: 'CR-V', child: Text('CR-V')),
                  DropdownMenuItem(value: 'Altima', child: Text('Altima')),
                ],
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
        Container(
          height: 120,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: ColorPalette.borderColor),
            borderRadius: BorderRadius.circular(8),
            color: ColorPalette.backgroundColor,
          ),
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
                style: TextStyle(color: ColorPalette.textSecondary),
              ),
            ],
          ),
        ),
     Center(
       child: AppButton(
                    text: 'Add Vehicle',
                    icon: Icons.chevron_right,
                    onPressed: () {
                      // Validations and next
                      notifier.nextStep();
                    },
                  ),
     ),
      ],
    );
  }
}
