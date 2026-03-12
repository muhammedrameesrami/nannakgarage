import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      final List<BookingModel> mockList = List.generate(10, (index) {
        final id = (page - 1) * 10 + index + 1;
        final statuses = ['Gate Entry', 'Job Card', 'Estimation', 'Service', 'Quality Check', 'Billing'];
        return BookingModel(
          id: id.toString(),
          bookingNumber: 'BKG-${id.toString().padLeft(3, '0')}',
          createdAt: DateTime.now().subtract(Duration(hours: id)),
          customer: CustomerModel(id: 'c$id', name: 'Customer $id', phone: '+1 234 567 89$index'),
          vehicle: VehicleModel(id: 'v$id', number: 'XYZ ${id}00', brand: 'Toyota', model: 'Model $index', kmDriven: '${id * 1000}'),
          status: statuses[index % statuses.length],
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

final bookingControllerProvider = NotifierProvider<BookingController, BookingState>(BookingController.new);
