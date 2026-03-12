import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../models/customer_model.dart';
import '../models/vehicle_model.dart';

class DashboardState {
  final bool isLoading;
  final double todayRevenue;
  final int totalVehiclesToday;
  final int completedServices;
  final int pendingServices;
  final List<BookingModel> recentBookings;

  const DashboardState({
    this.isLoading = false,
    this.todayRevenue = 0,
    this.totalVehiclesToday = 0,
    this.completedServices = 0,
    this.pendingServices = 0,
    this.recentBookings = const [],
  });

  DashboardState copyWith({
    bool? isLoading,
    double? todayRevenue,
    int? totalVehiclesToday,
    int? completedServices,
    int? pendingServices,
    List<BookingModel>? recentBookings,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      totalVehiclesToday: totalVehiclesToday ?? this.totalVehiclesToday,
      completedServices: completedServices ?? this.completedServices,
      pendingServices: pendingServices ?? this.pendingServices,
      recentBookings: recentBookings ?? this.recentBookings,
    );
  }
}

class DashboardController extends Notifier<DashboardState> {
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

      final mockBookings = [
        BookingModel(
          id: '1',
          bookingNumber: 'BKG-001',
          createdAt: DateTime.now(),
          customer: CustomerModel(id: 'c1', name: 'John Doe', phone: '+1 987 654 3210'),
          vehicle: VehicleModel(id: 'v1', number: 'KDB 654P', brand: 'Toyota', model: 'RAV4', kmDriven: '45,000'),
          status: 'Quality Check',
        ),
        BookingModel(
          id: '2',
          bookingNumber: 'BKG-002',
          createdAt: DateTime.now(),
          customer: CustomerModel(id: 'c2', name: 'Jane Smith', phone: '+1 123 456 7890'),
          vehicle: VehicleModel(id: 'v2', number: 'XMN 1234', brand: 'Honda', model: 'Civic', kmDriven: '32,000'),
          status: 'Billing',
        ),
        BookingModel(
          id: '3',
          bookingNumber: 'BKG-003',
          createdAt: DateTime.now(),
          customer: CustomerModel(id: 'c3', name: 'Robert Brown', phone: '+1 555 666 7777'),
          vehicle: VehicleModel(id: 'v3', number: 'LMH 8756', brand: 'Ford', model: 'F-150', kmDriven: '12,500'),
          status: 'Estimation',
        ),
      ];

      state = DashboardState(
        isLoading: false,
        todayRevenue: 4500.0,
        totalVehiclesToday: 15,
        completedServices: 8,
        pendingServices: 7,
        recentBookings: mockBookings,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final dashboardControllerProvider = NotifierProvider<DashboardController, DashboardState>(DashboardController.new);
