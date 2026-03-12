import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../controllers/workflow_controller.dart';
import '../dashboard/dashboard_screen.dart';

class ServiceCompletionScreen extends ConsumerWidget {
  const ServiceCompletionScreen({Key? key}) : super(key: key);

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
              'Service Completion',
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
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    (route) => false,
                  ),
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
        Text('Service Checklist', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 24),
        _buildServiceTask('General Service', true),
        _buildServiceTask('Oil Change', true),
        _buildServiceTask('Brake Pad Replacement', false, reason: 'Pending parts availability from warehouse.'),
      ],
    );
  }

  Widget _buildServiceTask(String title, bool isCompleted, {String? reason}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? ColorPalette.hoverColor.withOpacity(0.5) : Colors.white,
        border: Border.all(color: ColorPalette.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? ColorPalette.primaryColor : ColorPalette.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              Switch(
                value: isCompleted,
                onChanged: (val) {},
                activeColor: ColorPalette.primaryColor,
              ),
            ],
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            AppTextField(
              label: 'Reason for not completing',
              hint: 'Enter reason...',
              controller: TextEditingController(text: reason),
            ),
          ]
        ],
      ),
    );
  }
}
