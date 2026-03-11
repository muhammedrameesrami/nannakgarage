import 'package:flutter_riverpod/flutter_riverpod.dart';

class EstimationState {
  final double totalSparePartsCost;
  final double totalLabourCost;

  EstimationState({this.totalSparePartsCost = 0.0, this.totalLabourCost = 0.0});
}

class EstimationController extends Notifier<EstimationState> {
  @override
  EstimationState build() {
    return EstimationState();
  }

  void setCosts(double spareParts, double labour) {
    state = EstimationState(
      totalSparePartsCost: spareParts,
      totalLabourCost: labour,
    );
  }
}

final estimationControllerProvider =
    NotifierProvider<EstimationController, EstimationState>(() {
      return EstimationController();
    });
