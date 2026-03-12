import 'package:flutter/material.dart';
import '../../core/theme/color_palette.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          const SizedBox(height: 24),
          const Text(
            'Workflow Completed Successfully!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'The vehicle has been successfully released.',
            style: TextStyle(
              fontSize: 16,
              color: ColorPalette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
