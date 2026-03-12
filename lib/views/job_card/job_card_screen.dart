import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../controllers/workflow_controller.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class JobCardScreen extends ConsumerWidget {
  const JobCardScreen({Key? key}) : super(key: key);

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
              'Job Card',
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
        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                label: 'Technician Assignment',
                hint: 'Select Technician',
                items: const [],
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 32),
        const AppTextField(
          label: 'Customer Complaints',
          hint: 'Enter customer issues',
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        const AppTextField(
          label: 'Advisor Notes',
          hint: 'Enter advisor notes',
          maxLines: 4,
        ),
        const SizedBox(height: 32),
        Text('Inspection Checklist', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            _buildChecklistItem('Brakes'),
            _buildChecklistItem('Engine'),
            _buildChecklistItem('Lights'),
            _buildChecklistItem('Battery'),
            _buildChecklistItem('Suspension'),
          ],
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: false,
          onChanged: (val) {},
          activeColor: ColorPalette.primaryColor,
        ),
        Text(title),
      ],
    );
  }
}
