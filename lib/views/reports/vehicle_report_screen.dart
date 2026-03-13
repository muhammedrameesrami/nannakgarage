import 'package:flutter/material.dart';
import '../../core/theme/color_palette.dart';
import '../layout/app_layout.dart';

class VehicleReportScreen extends StatelessWidget {
  const VehicleReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/reports/vehicle',
      activeMainIndex: 2, // 2 is the index for Reports
      child: const VehicleReportContent(),
    );
  }
}

class VehicleReportContent extends StatelessWidget {
  const VehicleReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: ColorPalette.borderColor)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: ColorPalette.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'View all vehicle statistics and history',
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorPalette.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.directions_car_rounded,
                  size: 48,
                  color: ColorPalette.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vehicle Report Data Coming Soon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
