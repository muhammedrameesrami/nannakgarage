class EstimationModel {
  final String bookingId;
  final List<ServiceItem> services;
  final List<SparePart> spareParts;
  final double labourCharges;

  EstimationModel({
    required this.bookingId,
    required this.services,
    required this.spareParts,
    required this.labourCharges,
  });

  double get totalEstimate {
    double servicesCoist = services.fold(0, (sum, item) => sum + item.cost);
    double partsCost = spareParts.fold(0, (sum, item) => sum + item.price * item.quantity);
    return servicesCoist + partsCost + labourCharges;
  }
}

class ServiceItem {
  final String id;
  final String name;
  final double cost;

  ServiceItem({required this.id, required this.name, required this.cost});
}

class SparePart {
  final String id;
  final String name;
  final double price;
  final int quantity;

  SparePart({required this.id, required this.name, required this.price, this.quantity = 1});
}
