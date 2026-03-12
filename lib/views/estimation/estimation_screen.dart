import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../controllers/workflow_controller.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class EstimationScreen extends ConsumerWidget {
  const EstimationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(workflowControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Service Estimation',
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
                  onPressed: () => context.go(AppConstants.routeDashboard),
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: 'Previous',
                  isPrimary: false,
                  onPressed: () => notifier.previousStep(),
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: 'Save',
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: 'Next',
                  icon: Icons.chevron_right,
                  onPressed: () => notifier.nextStep(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Service List', () {}),
        const SizedBox(height: 16),
        _buildItemRow('General Service', '1', '\$150.00', '\$150.00'),
        _buildItemRow('Oil Change', '1', '\$45.00', '\$45.00'),
        const Divider(height: 32),
        
        _buildSectionHeader('Spare Parts', () {}),
        const SizedBox(height: 16),
        _buildItemRow('Brake Pads', '2', '\$60.00', '\$120.00'),
        _buildItemRow('Air Filter', '1', '\$25.00', '\$25.00'),
        const Divider(height: 32),
        
        const Text('Labour Charges', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        const SizedBox(
          width: 300,
          child: AppTextField(
            label: 'Amount',
            hint: '\$50.00',
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(width: 16),
            const Text(
              '\$390.00',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: ColorPalette.primaryColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_circle_outline, color: ColorPalette.primaryColor),
          label: const Text('Add Item', style: TextStyle(color: ColorPalette.primaryColor)),
        ),
      ],
    );
  }

  Widget _buildItemRow(String name, String qty, String price, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name)),
          Expanded(child: Text('Qty: $qty')),
          Expanded(child: Text(price)),
          Expanded(child: Text(total, style: const TextStyle(fontWeight: FontWeight.w600))),
          IconButton(
            icon: Icon(Icons.delete_outline, color: ColorPalette.statusError, size: 20),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
