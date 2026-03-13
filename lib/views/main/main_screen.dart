import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../models/booking_model.dart';
import '../bookings/booking_detail_screen.dart';
import '../bookings/bookings_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../layout/app_layout.dart';
import '../reports/reports_content.dart';
import '../reports/sales_report_screen.dart';
import '../reports/vehicle_report_screen.dart';
import '../workflow/workflow_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final String? initialBookingSection;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.initialBookingSection,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  static const int _dashboardTabIndex = 0;
  static const int _bookingsTabIndex = 1;
  static const int _bookingDetailTabIndex = 2;
  static const int _workflowTabIndex = 3;
  static const int _reportsOverviewTabIndex = 4;
  static const int _salesReportTabIndex = 5;
  static const int _vehicleReportTabIndex = 6;
  static const int _settingsTabIndex = 7;

  late final TabController _tabController;
  late int _activeIndex;
  BookingModel? _selectedBooking;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.initialIndex.clamp(0, _settingsTabIndex);
    _tabController = TabController(
      length: _settingsTabIndex + 1,
      vsync: this,
      initialIndex: _activeIndex,
    );
    _tabController.addListener(_syncIndexFromTabController);
  }

  @override
  void dispose() {
    _tabController.removeListener(_syncIndexFromTabController);
    _tabController.dispose();
    super.dispose();
  }

  void _syncIndexFromTabController() {
    if (_activeIndex != _tabController.index) {
      setState(() {
        _activeIndex = _tabController.index;
      });
    }
  }

  String _routeForIndex(int index) {
    if (index == _dashboardTabIndex) {
      return AppConstants.routeDashboard;
    }
    if (index == _bookingsTabIndex) {
      return AppConstants.routeBookings;
    }
    if (index == _bookingDetailTabIndex || index == _workflowTabIndex) {
      return AppConstants.routeBookings;
    }
    if (index == _reportsOverviewTabIndex) {
      return AppConstants.routeReports;
    }
    if (index == _salesReportTabIndex) {
      return '${AppConstants.routeReports}/sales';
    }
    if (index == _vehicleReportTabIndex) {
      return '${AppConstants.routeReports}/vehicle';
    }
    if (index == _settingsTabIndex) {
      return AppConstants.routeSettings;
    }
    return AppConstants.routeDashboard;
  }

  int _mainNavigationIndexForTab(int tabIndex) {
    if (tabIndex == _dashboardTabIndex) {
      return 0;
    }
    if (tabIndex == _bookingsTabIndex) {
      return 1;
    }
    if (tabIndex == _bookingDetailTabIndex || tabIndex == _workflowTabIndex) {
      return 1;
    }
    if (tabIndex == _settingsTabIndex) {
      return 3;
    }
    return 2;
  }

  int _tabIndexForMainNavigation(int navIndex) {
    switch (navIndex) {
      case 0:
        return _dashboardTabIndex;
      case 1:
        return _bookingsTabIndex;
      case 2:
        return _reportsOverviewTabIndex;
      case 3:
        return _settingsTabIndex;
      default:
        return _dashboardTabIndex;
    }
  }

  void _onSecondaryRouteTap(String route) {
    int targetTabIndex = _activeIndex;

    if (route == '${AppConstants.routeReports}/sales') {
      targetTabIndex = _salesReportTabIndex;
    } else if (route == '${AppConstants.routeReports}/vehicle') {
      targetTabIndex = _vehicleReportTabIndex;
    }

    if (targetTabIndex == _activeIndex) {
      return;
    }

    _tabController.animateTo(targetTabIndex);
    setState(() {
      _activeIndex = targetTabIndex;
    });
  }

  void _openBookingDetail(BookingModel booking) {
    setState(() {
      _selectedBooking = booking;
      _activeIndex = _bookingDetailTabIndex;
    });
    _tabController.animateTo(_bookingDetailTabIndex);
  }

  void _openWorkflow() {
    setState(() {
      _activeIndex = _workflowTabIndex;
    });
    _tabController.animateTo(_workflowTabIndex);
  }

  void _backToBookingsTab() {
    setState(() {
      _activeIndex = _bookingsTabIndex;
    });
    _tabController.animateTo(_bookingsTabIndex);
  }

  void _onMainNavigationTap(int index) {
    final targetTabIndex = _tabIndexForMainNavigation(index);
    if (targetTabIndex == _activeIndex) {
      return;
    }
    _tabController.animateTo(targetTabIndex);
    setState(() {
      _activeIndex = targetTabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: _routeForIndex(_activeIndex),
      activeMainIndex: _mainNavigationIndexForTab(_activeIndex),
      onMainNavigationTap: _onMainNavigationTap,
      onSecondaryRouteTap: _onSecondaryRouteTap,
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const DashboardOverviewContent(),
          BookingsContent(
            initialSection: widget.initialBookingSection,
            onOpenBookingDetail: _openBookingDetail,
            onStartWorkflow: _openWorkflow,
          ),
          _selectedBooking == null
              ? const SizedBox.shrink()
              : BookingDetailContent(
                  booking: _selectedBooking!,
                  onBack: _backToBookingsTab,
                ),
          const WorkflowContent(),
          ReportsContent(onNavigateToTab: _tabController.animateTo),
          const SalesReportContent(),
          const VehicleReportContent(),
          const _ComingSoonPage(title: 'Settings'),
        ],
      ),
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  final String title;

  const _ComingSoonPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Coming Soon',
        style: const TextStyle(
          color: ColorPalette.textSecondary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
