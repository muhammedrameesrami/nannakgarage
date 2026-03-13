import 'package:flutter/material.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';

class ReportsContent extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const ReportsContent({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final reports = [
      {
        'title': 'Sales Report',
        'subtitle': 'Gate exit vehicles and billing summary',
        'icon': Icons.point_of_sale_rounded,
        'color': ColorPalette.primaryColor,
        'tabIndex': 3,
      },
      {
        'title': 'Vehicle Report',
        'subtitle': 'View all vehicle statistics and history',
        'icon': Icons.directions_car_rounded,
        'color': const Color(0xFF0EA5E9),
        'tabIndex': 4,
      },
    ];

    return Padding(
      padding: EdgeInsets.all(context.w(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports',
            style: TextStyle(
              fontSize: context.sp(28),
              fontWeight: FontWeight.bold,
              color: ColorPalette.textPrimary,
            ),
          ),
          SizedBox(height: context.h(32)),
          Wrap(
            spacing: context.w(20),
            runSpacing: context.h(20),
            children: reports.map((report) {
              return InkWell(
                onTap: () => onNavigateToTab(report['tabIndex']! as int),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: context.w(280),
                  padding: EdgeInsets.all(context.w(24)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorPalette.borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (report['color'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          report['icon'] as IconData,
                          color: report['color'] as Color,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: context.w(16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['title'] as String,
                              style: TextStyle(
                                fontSize: context.sp(16),
                                fontWeight: FontWeight.w700,
                                color: ColorPalette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              report['subtitle'] as String,
                              style: TextStyle(
                                fontSize: context.sp(12),
                                color: ColorPalette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: ColorPalette.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
