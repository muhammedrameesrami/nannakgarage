class VehicleModel {
  final String id;
  final String number;
  final String brand;
  final String model;
  final String? year;
  final String kmDriven;

  VehicleModel({
    required this.id,
    required this.number,
    required this.brand,
    required this.model,
    this.year,
    required this.kmDriven,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      number: json['number'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      kmDriven: json['kmDriven'],
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
    };
  }
  
  String get displayName => '$brand $model';
}
