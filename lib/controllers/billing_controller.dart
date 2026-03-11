import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/billing_model.dart';

class BillingController extends Notifier<BillingModel?> {
  @override
  BillingModel? build() {
    return null;
  }

  void generateBill(BillingModel bill) {
    state = bill;
  }
}

final billingControllerProvider =
    NotifierProvider<BillingController, BillingModel?>(() {
      return BillingController();
    });
