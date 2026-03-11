import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gate_entry_model.dart';

class GateEntryController extends Notifier<List<GateEntryModel>> {
  @override
  List<GateEntryModel> build() {
    return [];
  }

  void addEntry(GateEntryModel entry) {
    state = [...state, entry];
  }
}

final gateEntryControllerProvider =
    NotifierProvider<GateEntryController, List<GateEntryModel>>(() {
      return GateEntryController();
    });
