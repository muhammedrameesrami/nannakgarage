import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../controllers/workflow_controller.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(workflowControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Billing Summary',
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
                  text: 'Generate Invoice',
                  onPressed: () {
                    // Finalize and go to dashboard
                    context.go(AppConstants.routeDashboard);
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer Summary', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildSummaryItem('Name', 'John Doe'),
                  _buildSummaryItem('Phone', '+1 987 654 3210'),
                  _buildSummaryItem('Vehicle', 'Toyota RAV4 - KDB 654P'),
                  const SizedBox(height: 32),
                  const Text('Service & Parts Summary', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildCostItem('General Service', '\$150.00'),
                  _buildCostItem('Oil Change', '\$45.00'),
                  _buildCostItem('Brake Pads (x2)', '\$120.00'),
                  _buildCostItem('Air Filter (x1)', '\$25.00'),
                  const Divider(),
                  _buildCostItem('Labour Charges', '\$50.00'),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorPalette.backgroundColor,
                  border: Border.all(color: ColorPalette.borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Payment Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                    const SizedBox(height: 24),
                    _buildTotalRow('Subtotal', '\$390.00'),
                    const SizedBox(height: 16),
                    const AppTextField(
                      label: 'Discount',
                      hint: '\$0.00',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        Text('\$390.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: ColorPalette.primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AppDropdown<String>(
                      label: 'Payment Method',
                      hint: 'Card',
                      items: const [
                        DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                        DropdownMenuItem(value: 'Card', child: Text('Card')),
                        DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: ColorPalette.textSecondary)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCostItem(String item, String cost) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item),
          Text(cost, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: ColorPalette.textSecondary, fontSize: 16)),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      ],
    );
  }
}
