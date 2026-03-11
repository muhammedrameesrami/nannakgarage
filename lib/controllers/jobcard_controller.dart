import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_card_model.dart';

class JobCardController extends Notifier<List<JobCardModel>> {
  @override
  List<JobCardModel> build() {
    return [];
  }

  void addJobCard(JobCardModel jobCard) {
    state = [...state, jobCard];
  }
}

final jobCardControllerProvider =
    NotifierProvider<JobCardController, List<JobCardModel>>(() {
      return JobCardController();
    });
