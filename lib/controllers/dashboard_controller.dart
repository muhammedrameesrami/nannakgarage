import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardState {
  final bool isLoading;
  final Map<String, int> sectionCounts;

  const DashboardState({this.isLoading = false, this.sectionCounts = const {}});

  DashboardState copyWith({bool? isLoading, Map<String, int>? sectionCounts}) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      sectionCounts: sectionCounts ?? this.sectionCounts,
    );
  }
}

class DashboardController extends Notifier<DashboardState> {
  static const String gateEntry = 'Gate Entry';
  static const String inventory = 'Inventory';
  static const String estimation = 'Estimation';
  static const String jobCard = 'Job Card';
  static const String technician = 'Technician';
  static const String qualityCheck = 'Quality Check';
  static const String billing = 'Billing';
  static const String gateExit = 'Gate Exit';

  static const List<String> workflowSections = [
    gateEntry,
    inventory,
    estimation,
    jobCard,
    technician,
    qualityCheck,
    billing,
    gateExit,
  ];

  @override
  DashboardState build() {
    // Initialize with empty state and then load
    Future(() => loadDashboardData());
    return const DashboardState(isLoading: true);
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate API Call
      await Future.delayed(const Duration(milliseconds: 800));

      // Dummy data until backend integration is completed.
      final counts = <String, int>{
        gateEntry: 14,
        inventory: 8,
        estimation: 9,
        jobCard: 11,
        technician: 7,
        qualityCheck: 5,
        billing: 4,
        gateExit: 3,
      };

      state = DashboardState(isLoading: false, sectionCounts: counts);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final dashboardControllerProvider =
    NotifierProvider<DashboardController, DashboardState>(
      DashboardController.new,
    );
