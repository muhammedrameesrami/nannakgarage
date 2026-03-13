class VehicleModel {
  final String id;
  final String number;
  final String brand;
  final String model;
  final String? year;
  final String kmDriven;
  final String? chassisNumber;
  final String? engineNumber;
  final String? registrationDate;
  final String? fuel;

  VehicleModel({
    required this.id,
    required this.number,
    required this.brand,
    required this.model,
    this.year,
    required this.kmDriven,
    this.chassisNumber,
    this.engineNumber,
    this.registrationDate,
    this.fuel,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      number: json['number'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      kmDriven: json['kmDriven'],
      chassisNumber: json['chassisNumber'],
      engineNumber: json['engineNumber'],
      registrationDate: json['registrationDate'],
      fuel: json['fuel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'brand': brand,
      'model': model,
      'year': year,
      'kmDriven': kmDriven,
      'chassisNumber': chassisNumber,
      'engineNumber': engineNumber,
      'registrationDate': registrationDate,
      'fuel': fuel,
    };
  }

  String get displayName => '$brand $model';
}
