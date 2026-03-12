import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../bookings/bookings_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../layout/app_layout.dart';

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
  late final TabController _tabController;
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.initialIndex.clamp(
      0,
      AppConstants.mainNavigationItems.length - 1,
    );
    _tabController = TabController(
      length: AppConstants.mainNavigationItems.length,
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
    return AppConstants.mainNavigationItems[index]['route'] as String;
  }

  void _onMainNavigationTap(int index) {
    if (index == _activeIndex) {
      return;
    }
    _tabController.animateTo(index);
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: _routeForIndex(_activeIndex),
      activeMainIndex: _activeIndex,
      onMainNavigationTap: _onMainNavigationTap,
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const DashboardOverviewContent(),
          BookingsContent(initialSection: widget.initialBookingSection),
          const _ComingSoonPage(title: 'Reports'),
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
