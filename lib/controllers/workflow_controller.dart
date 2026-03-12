import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../models/gate_entry_model.dart';
import '../core/constants/app_constants.dart';

class WorkflowState {
  final BookingModel? currentBooking;
  final String currentStep;
  final bool isLoading;
  final GateEntryModel? gateEntryDraft;

  const WorkflowState({
    this.currentBooking,
    this.currentStep = AppConstants.statusGateEntry,
    this.isLoading = false,
    this.gateEntryDraft,
  });

  WorkflowState copyWith({
    BookingModel? currentBooking,
    String? currentStep,
    bool? isLoading,
    GateEntryModel? gateEntryDraft,
  }) {
    return WorkflowState(
      currentBooking: currentBooking ?? this.currentBooking,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      gateEntryDraft: gateEntryDraft ?? this.gateEntryDraft,
    );
  }
}

class WorkflowController extends Notifier<WorkflowState> {
  @override
  WorkflowState build() => const WorkflowState();

  void startNewBooking() {
    state = const WorkflowState(currentStep: AppConstants.statusGateEntry);
  }

  void openBooking(BookingModel booking) {
    state = WorkflowState(
      currentBooking: booking,
      currentStep: booking.status,
    );
  }

  void nextStep() {
    final steps = AppConstants.workflowSteps;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex < steps.length - 1) {
      state = state.copyWith(currentStep: steps[currentIndex + 1]);
    }
  }

  void previousStep() {
    final steps = AppConstants.workflowSteps;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex > 0) {
      state = state.copyWith(currentStep: steps[currentIndex - 1]);
    }
  }

  void setStep(String stepName) {
    if (AppConstants.workflowSteps.contains(stepName)) {
      state = state.copyWith(currentStep: stepName);
    }
  }
}

final workflowControllerProvider = NotifierProvider<WorkflowController, WorkflowState>(WorkflowController.new);
