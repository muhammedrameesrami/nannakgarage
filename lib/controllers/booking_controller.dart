import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../models/booking_model.dart';
import '../models/customer_model.dart';
import '../models/vehicle_model.dart';

class BookingState {
  final bool isLoading;
  final List<BookingModel> bookings;
  final int currentPage;
  final int totalPages;

  const BookingState({
    this.isLoading = false,
    this.bookings = const [],
    this.currentPage = 1,
    this.totalPages = 1,
  });

  BookingState copyWith({
    bool? isLoading,
    List<BookingModel>? bookings,
    int? currentPage,
    int? totalPages,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      bookings: bookings ?? this.bookings,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class BookingController extends Notifier<BookingState> {
  @override
  BookingState build() {
    Future(() => loadBookings(1));
    return const BookingState(isLoading: true);
  }

  Future<void> loadBookings(int page) async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate API Call
      await Future.delayed(const Duration(milliseconds: 600));

      final List<BookingModel> mockList = List.generate(20, (index) {
        final id = (page - 1) * 20 + index + 1;
        final statuses = [
          AppConstants.statusGateEntry,
          AppConstants.statusJobCard,
          AppConstants.statusEstimation,
          AppConstants.statusService,
          AppConstants.statusQualityCheck,
          AppConstants.statusBilling,
          AppConstants.statusGateExit,
          AppConstants.statusCompleted,
        ];

        // Ensure variety and specifically include Gate Exit items
        String status;
        if (index % 5 == 0) {
          status = AppConstants.statusGateExit;
        } else {
          status = statuses[index % statuses.length];
        }

        final serviceTypes = [
          'Full Service',
          'Oil Change',
          'Body Repair',
          'Engine Tune-up',
          'Brake Service',
        ];
        final fuels = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'CNG'];

        return BookingModel(
          id: id.toString(),
          bookingNumber: 'BKG-${id.toString().padLeft(3, '0')}',
          createdAt: DateTime.now().subtract(Duration(hours: id)),
          customer: CustomerModel(
            id: 'c$id',
            name: 'Customer $id',
            phone: '+1 234 567 89$index',
            address: 'Location ${index + 1}',
          ),
          vehicle: VehicleModel(
            id: 'v$id',
            number: 'XYZ ${id}00',
            brand: 'Toyota',
            model: 'Model $index',
            kmDriven: '${id * 1000}',
            chassisNumber: 'CHS${id.toString().padLeft(6, '0')}',
            engineNumber: 'ENG${id.toString().padLeft(6, '0')}',
            registrationDate: '2024-0${(index % 9) + 1}-15',
            fuel: fuels[index % fuels.length],
          ),
          status: status,
          serviceType: serviceTypes[index % serviceTypes.length],
          estimatedCost: (id * 500.0) + 1000,
          finalCost: (id * 500.0) + 800,
        );
      });

      state = state.copyWith(
        isLoading: false,
        bookings: mockList,
        currentPage: page,
        totalPages: 5,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final bookingControllerProvider =
    NotifierProvider<BookingController, BookingState>(BookingController.new);
