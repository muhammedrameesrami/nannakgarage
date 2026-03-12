import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../controllers/workflow_controller.dart';
import '../main/main_screen.dart';

class GateEntryScreen extends ConsumerStatefulWidget {
  const GateEntryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GateEntryScreen> createState() => _GateEntryScreenState();
}

class _GateEntryScreenState extends ConsumerState<GateEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(workflowControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gate Entry',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
            ),
            Row(
              children: [
                AppButton(
                  text: 'Cancel',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(initialIndex: 0),
                      ),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: 'Save',
                  onPressed: () {}, // Save functionality
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: 'Next',
                  icon: Icons.chevron_right,
                  onPressed: () {
                    // Validations and next
                    notifier.nextStep();
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text('Customer Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: AppTextField(label: 'Customer Name', hint: 'John Doe')),
            const SizedBox(width: 24),
            Expanded(child: AppTextField(label: 'Customer Phone', hint: '+1 987 654 3210', keyboardType: TextInputType.phone)),
          ],
        ),
        const SizedBox(height: 32),
        const Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                label: 'Area',
                hint: 'Downtown',
                items: const [],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppDropdown<String>(
                label: 'Brand',
                hint: 'Toyota',
                items: const [],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppDropdown<String>(
                label: 'Model',
                hint: 'RAV4',
                items: const [],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(child: AppTextField(label: 'Vehicle Number', hint: 'KDB 654P')),
            const SizedBox(width: 24),
            const Expanded(child: AppTextField(label: 'KM Driven', hint: '75,500 km')),
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
              Icon(Icons.camera_alt_outlined, size: 32, color: ColorPalette.textSecondary),
              const SizedBox(height: 8),
              const Text('Upload Photo', style: TextStyle(color: ColorPalette.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
