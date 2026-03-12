import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../controllers/workflow_controller.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class QualityCheckScreen extends ConsumerWidget {
  const QualityCheckScreen({Key? key}) : super(key: key);

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
              'Quality Check',
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
        Text('Inspection Checklist', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 24),
        _buildQualityRow('Brake Test', true),
        _buildQualityRow('Engine Test', true),
        _buildQualityRow('Suspension Test', false, failReason: 'Suspension noise during test drive'),
      ],
    );
  }

  Widget _buildQualityRow(String testName, bool isPass, {String? failReason}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ColorPalette.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_box,
            color: ColorPalette.primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              testName,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          if (!isPass)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: AppDropdown<String>(
                  label: '',
                  hint: failReason,
                  items: const [],
                ),
              ),
            )
          else
            const Spacer(flex: 4),
          SizedBox(
            width: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: ColorPalette.borderColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isPass ? 'Pass' : 'Fail'),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: ColorPalette.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
