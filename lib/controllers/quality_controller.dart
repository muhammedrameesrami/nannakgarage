import 'package:flutter_riverpod/flutter_riverpod.dart';

class QualityController extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    return {};
  }

  void updateChecklist(String item, bool pass) {
    state = {...state, item: pass};
  }
}

final qualityControllerProvider =
    NotifierProvider<QualityController, Map<String, bool>>(() {
      return QualityController();
    });
