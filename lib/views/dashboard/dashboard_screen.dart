import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/dashboard_card.dart';
import '../../common/widgets/status_badge.dart';
import '../../common/widgets/loading_widget.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/workflow_controller.dart';
import '../layout/app_layout.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);

    return AppLayout(
      currentRoute: AppConstants.routeDashboard,
      child: state.isLoading
          ? const LoadingWidget()
          : Padding(
              padding: EdgeInsets.all(context.w(32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard Overview',
                        style: TextStyle(
                          fontSize: context.sp(28),
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      AppButton(
                        text: 'Add Booking',
                        icon: Icons.add,
                        onPressed: () {
                          ref.read(workflowControllerProvider.notifier).startNewBooking();
                          context.go(AppConstants.routeWorkflow);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(32)),
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: DashboardCard(
                          title: 'Daily Revenue',
                          value: '\$${state.todayRevenue.toStringAsFixed(0)}',
                          imagePath: AssetConstants.billing,
                        ),
                      ),
                      SizedBox(width: context.w(20)),
                      Expanded(
                        child: DashboardCard(
                          title: 'Today\'s Vehicles',
                          value: '${state.totalVehiclesToday}',
                          imagePath: AssetConstants.gateEntry,
                        ),
                      ),
                      SizedBox(width: context.w(20)),
                      Expanded(
                        child: DashboardCard(
                          title: 'Completed',
                          value: '${state.completedServices}',
                          imagePath: AssetConstants.serviceUpdate,
                        ),
                      ),
                      SizedBox(width: context.w(20)),
                      Expanded(
                        child: DashboardCard(
                          title: 'Pending',
                          value: '${state.pendingServices}',
                          imagePath: AssetConstants.jobCard,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(40)),
                  // Recent Bookings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Service Bookings',
                        style: TextStyle(
                          fontSize: context.sp(20),
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppConstants.routeBookings),
                        child: const Text('View All Bookings'),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(16)),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorPalette.borderColor.withOpacity(0.5)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ListView.separated(
                          itemCount: state.recentBookings.length + 1, // +1 for header
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Header
                              return Container(
                                color: ColorPalette.backgroundColor.withOpacity(0.5),
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(24),
                                  vertical: context.h(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text('VEHICLE NO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(13), color: ColorPalette.textSecondary, letterSpacing: 1))),
                                    Expanded(flex: 2, child: Text('VEHICLE NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(13), color: ColorPalette.textSecondary, letterSpacing: 1))),
                                    Expanded(flex: 2, child: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(13), color: ColorPalette.textSecondary, letterSpacing: 1))),
                                    Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(13), color: ColorPalette.textSecondary, letterSpacing: 1))),
                                  ],
                                ),
                              );
                            }
                            
                            final booking = state.recentBookings[index - 1];
                            return InkWell(
                              onTap: () {
                                ref.read(workflowControllerProvider.notifier).openBooking(booking);
                                context.go(AppConstants.routeWorkflow);
                              },
                              hoverColor: ColorPalette.hoverColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(24),
                                  vertical: context.h(18),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(booking.vehicle.number, style: const TextStyle(fontWeight: FontWeight.bold, color: ColorPalette.primaryColor))),
                                    Expanded(flex: 2, child: Text(booking.vehicle.displayName, style: const TextStyle(fontWeight: FontWeight.w500))),
                                    Expanded(flex: 2, child: Text(booking.customer.name)),
                                    Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: StatusBadge(status: booking.status))),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
