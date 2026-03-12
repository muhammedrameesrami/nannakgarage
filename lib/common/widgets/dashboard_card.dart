import 'package:flutter/material.dart';
import '../../core/theme/color_palette.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final String? imagePath;
  final Color? accentColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.imagePath,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? ColorPalette.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: imagePath != null
                  ? Image.asset(imagePath!, height: 30, width: 30)
                  : Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                color: ColorPalette.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: ColorPalette.textSecondary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: ColorPalette.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
