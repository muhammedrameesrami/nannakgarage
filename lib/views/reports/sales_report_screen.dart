import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/status_badge.dart';
import '../../controllers/booking_controller.dart';
import '../layout/app_layout.dart';

class SalesReportScreen extends ConsumerWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingControllerProvider);
    final gateExitBookings = state.bookings
        .where((b) => b.status == AppConstants.statusGateExit)
        .toList();

    final totalAmount = gateExitBookings.fold<double>(
      0,
      (sum, b) => sum + (b.finalCost ?? 0),
    );

    return AppLayout(
      currentRoute: '${AppConstants.routeReports}/sales',
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: ColorPalette.textPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sales Report',
                  style: TextStyle(
                    fontSize: context.sp(24),
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(16)),

            // Total amount card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.w(20)),
              decoration: BoxDecoration(
                color: ColorPalette.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorPalette.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: ColorPalette.primaryColor,
                    size: 32,
                  ),
                  SizedBox(width: context.w(16)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Sales Amount',
                        style: TextStyle(
                          fontSize: context.sp(13),
                          color: ColorPalette.textSecondary,
                        ),
                      ),
                      Text(
                        '₹ ${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: context.sp(24),
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Vehicles',
                        style: TextStyle(
                          fontSize: context.sp(13),
                          color: ColorPalette.textSecondary,
                        ),
                      ),
                      Text(
                        '${gateExitBookings.length}',
                        style: TextStyle(
                          fontSize: context.sp(24),
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(20)),

            // Scrollable table
            Expanded(
              child: Card(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          // Table header
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(24),
                              vertical: context.h(16),
                            ),
                            child: Row(
                              children: [
                                _headerCell(context, 'Vehicle Number', 2),
                                _headerCell(context, 'Customer', 2),
                                _headerCell(context, 'Service Type', 2),
                                _headerCell(context, 'Status', 1),
                                _headerCell(context, 'Amount', 2),
                              ],
                            ),
                          ),
                          const Divider(),
                          // Table body
                          Expanded(
                            child: gateExitBookings.isEmpty
                                ? Center(
                                    child: Text(
                                      'No gate exit vehicles found.',
                                      style: TextStyle(
                                        color: ColorPalette.textSecondary,
                                        fontSize: context.sp(14),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: gateExitBookings.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(),
                                    itemBuilder: (context, index) {
                                      final booking =
                                          gateExitBookings[index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.w(24),
                                          vertical: context.h(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                booking.vehicle.number,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: context.sp(14),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                booking.customer.name,
                                                style: TextStyle(
                                                  fontSize: context.sp(14),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                booking.serviceType,
                                                style: TextStyle(
                                                  fontSize: context.sp(14),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerLeft,
                                                child: StatusBadge(
                                                  status: booking.status,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '₹ ${(booking.finalCost ?? 0).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: context.sp(14),
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorPalette
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(BuildContext context, String title, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: ColorPalette.textSecondary,
          fontSize: context.sp(14),
        ),
      ),
    );
  }
}
