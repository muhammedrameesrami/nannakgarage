class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}
