import 'package:flutter/material.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import 'sales_report_screen.dart';

class ReportsContent extends StatelessWidget {
  const ReportsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reports = [
      {
        'title': 'Sales Report',
        'subtitle': 'Gate exit vehicles and billing summary',
        'icon': Icons.point_of_sale_rounded,
        'color': ColorPalette.primaryColor,
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
                onTap: () {
                  if (report['title'] == 'Sales Report') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SalesReportScreen(),
                      ),
                    );
                  }
                },
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
                          color: (report['color'] as Color).withOpacity(0.1),
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
