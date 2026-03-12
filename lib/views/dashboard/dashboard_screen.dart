import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/dashboard_card.dart';
import '../../common/widgets/loading_widget.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/workflow_controller.dart';
import '../layout/app_layout.dart';
import '../workflow/workflow_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      currentRoute: AppConstants.routeDashboard,
      child: const DashboardOverviewContent(),
    );
  }
}

class DashboardOverviewContent extends ConsumerWidget {
  const DashboardOverviewContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);

    return state.isLoading
        ? const LoadingWidget()
        : SingleChildScrollView(
            padding: EdgeInsets.all(
              context.screenWidth < 768 ? 16 : context.w(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        fontSize: context.csp(28, minSize: 24),
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                    AppButton(
                      text: 'Add Booking',
                      icon: Icons.add,
                      onPressed: () {
                        ref
                            .read(workflowControllerProvider.notifier)
                            .startNewBooking();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkflowScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: context.h(24)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    context.screenWidth < 768 ? 16 : context.w(20),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorPalette.primaryColor.withValues(alpha: 0.12),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ColorPalette.borderColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int columns = 1;
                      if (width >= 1280) {
                        columns = 4;
                      } else if (width >= 900) {
                        columns = 3;
                      } else if (width >= 640) {
                        columns = 2;
                      }

                      final horizontalGap = context.screenWidth < 768 ? 12.0 : 18.0;
                      final verticalGap = context.screenWidth < 768 ? 12.0 : 18.0;
                      final cardWidth =
                          (width - ((columns - 1) * horizontalGap)) / columns;

                      return Wrap(
                        spacing: horizontalGap,
                        runSpacing: verticalGap,
                        children: DashboardController.workflowSections.map((
                          section,
                        ) {
                          final visual = _sectionVisuals[section]!;
                          return SizedBox(
                            width: cardWidth,
                            child: DashboardCard(
                              title: section,
                              value: '${state.sectionCounts[section] ?? 0}',
                              imagePath: visual.imagePath,
                              accentColor: visual.color,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

class _SectionVisual {
  final String imagePath;
  final Color color;

  const _SectionVisual({required this.imagePath, required this.color});
}

const Map<String, _SectionVisual> _sectionVisuals = {
  DashboardController.gateEntry: _SectionVisual(
    imagePath: AssetConstants.gateEntry,
    color: Color(0xFF0D9488),
  ),
  DashboardController.estimation: _SectionVisual(
    imagePath: AssetConstants.estimation,
    color: Color(0xFFF59E0B),
  ),
  DashboardController.jobCard: _SectionVisual(
    imagePath: AssetConstants.jobCard,
    color: Color(0xFF3B82F6),
  ),
  DashboardController.technician: _SectionVisual(
    imagePath: AssetConstants.technician,
    color: Color(0xFF8B5CF6),
  ),
  DashboardController.qualityCheck: _SectionVisual(
    imagePath: AssetConstants.qualityCheck,
    color: Color(0xFF22C55E),
  ),
  DashboardController.billing: _SectionVisual(
    imagePath: AssetConstants.billing,
    color: Color(0xFFEF4444),
  ),
  DashboardController.gateExit: _SectionVisual(
    imagePath: AssetConstants.gateExit,
    color: Color(0xFF64748B),
  ),
};
