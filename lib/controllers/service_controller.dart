import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';

class ServiceController extends Notifier<List<ServiceModel>> {
  @override
  List<ServiceModel> build() {
    return [
      ServiceModel(
        id: '1',
        name: 'Oil Change',
        description: 'Engine oil replacement',
      ),
      ServiceModel(
        id: '2',
        name: 'Brake Inspection',
        description: 'Checking brake pads and discs',
      ),
    ];
  }

  void toggleServiceCompletion(String id, bool isCompleted) {
    state = state.map((service) {
      if (service.id == id) {
        return ServiceModel(
          id: service.id,
          name: service.name,
          description: service.description,
          isCompleted: isCompleted,
        );
      }
      return service;
    }).toList();
  }
}

final serviceControllerProvider =
    NotifierProvider<ServiceController, List<ServiceModel>>(() {
      return ServiceController();
    });
