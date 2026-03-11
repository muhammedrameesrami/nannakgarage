class GateEntryModel {
  final String customerName;
  final String customerPhone;
  final String vehicleNumber;
  final String kmDriven;
  final String? imageUrl;
  final String areaName;

  GateEntryModel({
    required this.customerName,
    required this.customerPhone,
    required this.vehicleNumber,
    required this.kmDriven,
    this.imageUrl,
    required this.areaName,
  });
}
