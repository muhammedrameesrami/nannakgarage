import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  Color _getStatusColor() {
    switch (status) {
      case AppConstants.statusGateEntry:
        return const Color(0xFF95A5A6); // Gray
      case AppConstants.statusJobCard:
        return const Color(0xFF3498DB); // Blue
      case AppConstants.statusEstimation:
        return const Color(0xFFF39C12); // Orange
      case AppConstants.statusService:
        return const Color(0xFF9B59B6); // Purple
      case AppConstants.statusQualityCheck:
        return ColorPalette.primaryColor; // Green
      case AppConstants.statusBilling:
        return const Color(0xFFE67E22); // Deep Orange
      case 'Completed':
        return ColorPalette.statusCompleted;
      case 'Pending':
        return ColorPalette.statusPending;
      default:
        return ColorPalette.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
