import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../common/widgets/status_badge.dart';
import '../../common/widgets/pagination_widget.dart';
import '../../common/widgets/loading_widget.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/workflow_controller.dart';
import '../layout/app_layout.dart';
import '../workflow/workflow_screen.dart';

class BookingsScreen extends ConsumerWidget {
  final String? initialSection;

  const BookingsScreen({Key? key, this.initialSection}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      currentRoute: AppConstants.routeBookings,
      child: BookingsContent(initialSection: initialSection),
    );
  }
}

class BookingsContent extends ConsumerWidget {
  final String? initialSection;

  const BookingsContent({super.key, this.initialSection});

  String? _stepForSection(String? section) {
    switch (section) {
      case DashboardController.gateEntry:
        return AppConstants.statusGateEntry;
      case DashboardController.jobCard:
        return AppConstants.statusJobCard;
      case DashboardController.estimation:
        return AppConstants.statusEstimation;
      case DashboardController.technician:
        return AppConstants.statusService;
      case DashboardController.qualityCheck:
        return AppConstants.statusQualityCheck;
      case DashboardController.billing:
        return AppConstants.statusBilling;
      case DashboardController.gateExit:
        return AppConstants.statusBilling;
      default:
        return null;
    }
  }

  String _canonical(String value) {
    return value.toLowerCase().replaceAll(' ', '');
  }

  bool _matchesSection(String bookingStatus, String section) {
    final normalizedStatus = _canonical(bookingStatus);
    final normalizedSection = _canonical(section);

    if (normalizedSection == _canonical(DashboardController.technician)) {
      return normalizedStatus == _canonical(AppConstants.statusService);
    }
    if (normalizedSection == _canonical(DashboardController.qualityCheck)) {
      return normalizedStatus == _canonical(AppConstants.statusQualityCheck) ||
          normalizedStatus == 'qualitycheck';
    }
    if (normalizedSection == _canonical(DashboardController.gateExit)) {
      return normalizedStatus == _canonical(AppConstants.statusBilling);
    }

    return normalizedStatus == normalizedSection;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingControllerProvider);
    final notifier = ref.read(bookingControllerProvider.notifier);
    final selectedSection = initialSection;
    final bookings = selectedSection == null
        ? state.bookings
        : state.bookings
              .where(
                (booking) => _matchesSection(booking.status, selectedSection),
              )
              .toList();
    final isGateEntrySection = selectedSection == DashboardController.gateEntry;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(context.w(32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: context.w(16),
                runSpacing: context.h(16),
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(
                    selectedSection == null
                        ? 'Bookings'
                        : '$selectedSection Vehicles',
                    style: TextStyle(
                      fontSize: context.sp(28),
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  Wrap(
                    spacing: context.w(16),
                    runSpacing: context.h(16),
                    children: [
                      SizedBox(
                        width: context.w(250),
                        child: AppTextField(
                          label: '',
                          hint: 'Search vehicles...',
                          prefixIcon: const Icon(Icons.search),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: context.w(150),
                        child: AppDropdown<String>(
                          label: '',
                          hint: 'Status',
                          items: const [],
                          onChanged: (val) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.h(32)),
              Expanded(
                child: Card(
                  child: state.isLoading
                      ? const LoadingWidget()
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(24),
                                vertical: context.h(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Vehicle Number',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorPalette.textSecondary,
                                        fontSize: context.sp(14),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Vehicle Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorPalette.textSecondary,
                                        fontSize: context.sp(14),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Customer Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorPalette.textSecondary,
                                        fontSize: context.sp(14),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorPalette.textSecondary,
                                        fontSize: context.sp(14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: bookings.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No vehicles found in this section.',
                                        style: TextStyle(
                                          color: ColorPalette.textSecondary,
                                          fontSize: context.sp(14),
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: bookings.length,
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                      itemBuilder: (context, index) {
                                        final booking = bookings[index];
                                        return InkWell(
                                          onTap: () {
                                            final workflowNotifier = ref.read(
                                              workflowControllerProvider
                                                  .notifier,
                                            );
                                            workflowNotifier.openBooking(
                                              booking,
                                            );

                                            final targetStep = _stepForSection(
                                              selectedSection,
                                            );
                                            if (targetStep != null) {
                                              workflowNotifier.setStep(
                                                targetStep,
                                              );
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const WorkflowScreen(),
                                              ),
                                            );
                                          },
                                          hoverColor: ColorPalette.hoverColor,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: context.w(24),
                                              vertical: context.h(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    booking.vehicle.number,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: context.sp(14),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    booking.vehicle.displayName,
                                                    style: TextStyle(
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
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: StatusBadge(
                                                      status: booking.status,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            const Divider(),
                            Padding(
                              padding: EdgeInsets.all(context.w(16)),
                              child: PaginationWidget(
                                currentPage: state.currentPage,
                                totalPages: state.totalPages,
                                onPageChanged: (page) =>
                                    notifier.loadBookings(page),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
        if (isGateEntrySection)
          Positioned(
            right: context.w(32),
            bottom: context.h(32),
            child: FloatingActionButton.extended(
              onPressed: () {
                ref.read(workflowControllerProvider.notifier).startNewBooking();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkflowScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
              backgroundColor: ColorPalette.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }
}
