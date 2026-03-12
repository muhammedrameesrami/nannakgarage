import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/dashboard_card.dart';
import '../../common/widgets/loading_widget.dart';
import '../../common/widgets/status_badge.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/workflow_controller.dart';
import '../../models/booking_model.dart';
import '../layout/app_layout.dart';
import '../billing/billing_screen.dart';
import '../estimation/estimation_screen.dart';
import '../gate_entry/gate_entry_screen.dart';
import '../gate_exit/gate_exit_screen.dart';
import '../job_card/job_card_screen.dart';
import '../quality/quality_check_screen.dart';
import '../service/service_completion_screen.dart';
import '../workflow/completed_screen.dart';

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

class DashboardOverviewContent extends ConsumerStatefulWidget {
  const DashboardOverviewContent({super.key});

  @override
  ConsumerState<DashboardOverviewContent> createState() =>
      _DashboardOverviewContentState();
}

class _DashboardOverviewContentState
    extends ConsumerState<DashboardOverviewContent> {
  String? _selectedSection;
  bool _showSectionForm = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _canonical(String value) => value.toLowerCase().replaceAll(' ', '');

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
      return normalizedStatus == _canonical(AppConstants.statusGateExit);
    }

    return normalizedStatus == normalizedSection;
  }

  void _openSectionList(String section) {
    setState(() {
      _selectedSection = section;
      _showSectionForm = false;
    });
  }

  void _openOverview() {
    setState(() {
      _selectedSection = null;
      _showSectionForm = false;
    });
  }

  void _openSectionFormFromBooking(BookingModel booking) {
    ref.read(workflowControllerProvider.notifier).openBooking(booking);
    setState(() {
      _showSectionForm = true;
    });
  }

  void _startGateEntry() {
    ref.read(workflowControllerProvider.notifier).startNewBooking();
    setState(() {
      _showSectionForm = true;
    });
  }

  Widget _buildFormContent() {
    final step = ref.watch(workflowControllerProvider).currentStep;

    switch (step) {
      case AppConstants.statusGateEntry:
        return const GateEntryScreen();
      case AppConstants.statusJobCard:
        return const JobCardScreen();
      case AppConstants.statusEstimation:
        return const EstimationScreen();
      case AppConstants.statusService:
        return const ServiceCompletionScreen();
      case AppConstants.statusQualityCheck:
        return const QualityCheckScreen();
      case AppConstants.statusBilling:
        return const BillingScreen();
      case AppConstants.statusGateExit:
        return const GateExitScreen();
      case AppConstants.statusCompleted:
        return const CompletedScreen();
      default:
        return const Center(child: Text('Unknown Step'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final bookingState = ref.watch(bookingControllerProvider);

    final query = _searchController.text.toLowerCase();
    final sectionBookings = _selectedSection == null
        ? const <BookingModel>[]
        : bookingState.bookings.where((booking) {
            final matchesSection = _matchesSection(
              booking.status,
              _selectedSection!,
            );
            if (!matchesSection) return false;
            if (query.isEmpty) return true;

            return booking.vehicle.number.toLowerCase().contains(query) ||
                booking.vehicle.displayName.toLowerCase().contains(query) ||
                booking.customer.name.toLowerCase().contains(query);
          }).toList();

    final showGateEntryFab =
        _selectedSection == DashboardController.gateEntry && !_showSectionForm;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(
            context.screenWidth < 768 ? 16 : context.w(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedSection == null)
                _buildOverview(dashboardState)
              else if (_showSectionForm)
                _buildSectionFormView()
              else
                _buildSectionListView(
                  section: _selectedSection!,
                  bookingState: bookingState,
                  bookings: sectionBookings,
                ),
            ],
          ),
        ),
        if (showGateEntryFab)
          Positioned(
            right: context.w(24),
            bottom: context.h(24),
            child: FloatingActionButton.extended(
              onPressed: _startGateEntry,
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
              backgroundColor: ColorPalette.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildOverview(DashboardState dashboardState) {
    if (dashboardState.isLoading) {
      return const Expanded(child: LoadingWidget());
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: TextStyle(
                fontSize: context.csp(28, minSize: 24),
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
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
                          value:
                              '${dashboardState.sectionCounts[section] ?? 0}',
                          imagePath: visual.imagePath,
                          accentColor: visual.color,
                          onTap: () => _openSectionList(section),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionListView({
    required String section,
    required BookingState bookingState,
    required List<BookingModel> bookings,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _openOverview,
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to Overview',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$section Vehicles',
                  style: TextStyle(
                    fontSize: context.csp(28, minSize: 24),
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: context.w(320),
                height: 45,
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search vehicles...',
                    hintStyle: TextStyle(
                      color: ColorPalette.textMuted,
                      fontSize: context.sp(14),
                    ),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ColorPalette.borderColor.withValues(alpha: 0.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ColorPalette.borderColor.withValues(alpha: 0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorPalette.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
          Expanded(
            child: Card(
              child: bookingState.isLoading
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
                              _headerText('Vehicle Number'),
                              _headerText('Brand & Model'),
                              _headerText('Customer Name'),
                              _headerText('Status'),
                              _headerText('Date'),
                            ],
                          ),
                        ),
                        const Divider(color: ColorPalette.primaryColor),
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
                                      onTap: () =>
                                          _openSectionFormFromBooking(booking),
                                      hoverColor: ColorPalette.hoverColor,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.w(24),
                                          vertical: context.h(16),
                                        ),
                                        child: Row(
                                          children: [
                                            _cellText(
                                              booking.vehicle.number,
                                              bold: true,
                                            ),
                                            _cellText(
                                              booking.vehicle.displayName,
                                            ),
                                            _cellText(booking.customer.name),
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: StatusBadge(
                                                  status: booking.status,
                                                ),
                                              ),
                                            ),
                                            _cellText(
                                              booking.createdAt.toString(),
                                            ),
                                          ],
                                        ),
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
    );
  }

  Widget _buildSectionFormView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _showSectionForm = false),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to Vehicle List',
              ),
              const SizedBox(width: 8),
              Text(
                _selectedSection ?? 'Section',
                style: TextStyle(
                  fontSize: context.csp(28, minSize: 24),
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: _buildFormContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: ColorPalette.textSecondary,
          fontSize: context.sp(14),
        ),
      ),
    );
  }

  Widget _cellText(String text, {bool bold = false}) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
          fontSize: context.sp(14),
        ),
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
