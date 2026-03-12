import 'customer_model.dart';
import 'vehicle_model.dart';

class BookingModel {
  final String id;
  final String bookingNumber;
  final DateTime createdAt;
  final CustomerModel customer;
  final VehicleModel vehicle;
  final String status;
  final double? estimatedCost;
  final double? finalCost;

  BookingModel({
    required this.id,
    required this.bookingNumber,
    required this.createdAt,
    required this.customer,
    required this.vehicle,
    required this.status,
    this.estimatedCost,
    this.finalCost,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      bookingNumber: json['bookingNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      customer: CustomerModel.fromJson(json['customer']),
      vehicle: VehicleModel.fromJson(json['vehicle']),
      status: json['status'],
      estimatedCost: json['estimatedCost']?.toDouble(),
      finalCost: json['finalCost']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingNumber': bookingNumber,
      'createdAt': createdAt.toIso8601String(),
      'customer': customer.toJson(),
      'vehicle': vehicle.toJson(),
      'status': status,
      'estimatedCost': estimatedCost,
      'finalCost': finalCost,
    };
  }

  BookingModel copyWith({
    String? id,
    String? bookingNumber,
    DateTime? createdAt,
    CustomerModel? customer,
    VehicleModel? vehicle,
    String? status,
    double? estimatedCost,
    double? finalCost,
  }) {
    return BookingModel(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      createdAt: createdAt ?? this.createdAt,
      customer: customer ?? this.customer,
      vehicle: vehicle ?? this.vehicle,
      status: status ?? this.status,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      finalCost: finalCost ?? this.finalCost,
    );
  }
}
