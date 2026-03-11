class BillingModel {
  final String id;
  final String jobId;
  final double totalAmount;
  final double discount;
  final double finalAmount;
  final String paymentMethod;
  final String narration;

  BillingModel({
    required this.id,
    required this.jobId,
    required this.totalAmount,
    this.discount = 0.0,
    required this.finalAmount,
    required this.paymentMethod,
    this.narration = '',
  });
}
