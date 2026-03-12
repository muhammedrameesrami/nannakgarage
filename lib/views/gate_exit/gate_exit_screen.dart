import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../controllers/workflow_controller.dart';

class GateExitScreen extends ConsumerWidget {
  const GateExitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: _buildUploadCard(
                title: 'Gate Pass image',
                icon: Icons.badge_outlined,
                onTap: () {
                  // Upload gate pass
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildUploadCard(
                title: 'Bill Upload',
                icon: Icons.receipt_long_outlined,
                onTap: () {
                  // Upload bill
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: ColorPalette.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorPalette.borderColor),
        ),
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
      ),
    );
  }
}
