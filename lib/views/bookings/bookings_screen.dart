import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../common/widgets/status_badge.dart';
import '../../common/widgets/pagination_widget.dart';
import '../../common/widgets/loading_widget.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/workflow_controller.dart';
import '../layout/app_layout.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      currentRoute: AppConstants.routeBookings,
      child: const BookingsContent(),
    );
  }
}

class BookingsContent extends ConsumerWidget {
  const BookingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingControllerProvider);
    final notifier = ref.read(bookingControllerProvider.notifier);

    return Padding(
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
                'Bookings',
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
                  AppButton(
                    text: 'Add Booking',
                    icon: Icons.add,
                    onPressed: () {
                      ref.read(workflowControllerProvider.notifier).startNewBooking();
                      Navigator.pushNamed(context, AppConstants.routeWorkflow);
                    },
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
                          child: ListView.separated(
                            itemCount: state.bookings.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final booking = state.bookings[index];
                              return InkWell(
                                onTap: () {
                                  ref
                                      .read(workflowControllerProvider.notifier)
                                      .openBooking(booking);
                                  Navigator.pushNamed(
                                    context,
                                    AppConstants.routeWorkflow,
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
                                            fontWeight: FontWeight.w500,
                                            fontSize: context.sp(14),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          booking.vehicle.displayName,
                                          style: TextStyle(fontSize: context.sp(14)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          booking.customer.name,
                                          style: TextStyle(fontSize: context.sp(14)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: StatusBadge(status: booking.status),
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
                            onPageChanged: (page) => notifier.loadBookings(page),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
