class QualityCheckModel {
  final String bookingId;
  final List<QualityInspectionItem> inspections;

  QualityCheckModel({
    required this.bookingId,
    required this.inspections,
  });
}

class QualityInspectionItem {
  final String id;
  final String area; // e.g., 'Brake Test', 'Engine Test'
  final bool isPass;
  final String? failReason;

  QualityInspectionItem({
    required this.id,
    required this.area,
    required this.isPass,
    this.failReason,
  });
}
