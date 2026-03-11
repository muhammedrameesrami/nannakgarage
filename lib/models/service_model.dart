class ServiceModel {
  final String id;
  final String name;
  final String description;
  bool isCompleted;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    this.isCompleted = false,
  });
}
