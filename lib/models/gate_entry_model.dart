class GateEntryModel {
  final String bookingId;
  final String customerName;
  final String customerPhone;
  final String vehicleNumber;
  final String vehicleBrand;
  final String vehicleModel;
  final String kmDriven;
  final String? imageUrl;
  final String? area;

  GateEntryModel({
    required this.bookingId,
    required this.customerName,
    required this.customerPhone,
    required this.vehicleNumber,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.kmDriven,
    this.imageUrl,
    this.area,
  });
}
