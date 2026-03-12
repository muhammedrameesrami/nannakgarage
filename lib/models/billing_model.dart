import 'customer_model.dart';
import 'vehicle_model.dart';
import 'estimation_model.dart';

class BillingModel {
  final String bookingId;
  final CustomerModel customer;
  final VehicleModel vehicle;
  final List<ServiceItem> services;
  final List<SparePart> spareParts;
  final double labourCharges;
  final double discount;
  final String paymentMethod; // e.g., Cash, Card, UPI

  BillingModel({
    required this.bookingId,
    required this.customer,
    required this.vehicle,
    required this.services,
    required this.spareParts,
    required this.labourCharges,
    this.discount = 0.0,
    required this.paymentMethod,
  });

  double get subTotal {
    double servicesCost = services.fold(0, (sum, item) => sum + item.cost);
    double partsCost = spareParts.fold(0, (sum, item) => sum + item.price * item.quantity);
    return servicesCost + partsCost + labourCharges;
  }

  double get finalAmount => subTotal - discount;
}
