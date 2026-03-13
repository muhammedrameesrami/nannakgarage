import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../controllers/workflow_controller.dart';
import '../layout/app_layout.dart';
import '../gate_entry/gate_entry_screen.dart';
import '../job_card/job_card_screen.dart';
import '../estimation/estimation_screen.dart';
import '../service/service_completion_screen.dart';
import '../quality/quality_check_screen.dart';
import '../billing/billing_screen.dart';

class WorkflowContent extends ConsumerWidget {
  const WorkflowContent({super.key});

  Widget _buildCurrentStepView(String currentStep) {
    switch (currentStep) {
      case AppConstants.statusGateEntry:
        return const GateEntryScreen();
      case AppConstants.statusJobCard:
        return const JobCardScreen();
      case AppConstants.statusEstimation:
        return const EstimationScreen();
      case AppConstants.statusService:
        return const ServiceCompletionScreen();
      case AppConstants.statusQualityCheck:
        return const QualityCheckScreen();
      case AppConstants.statusBilling:
        return const BillingScreen();
      default:
        return const Center(child: Text('Unknown Step'));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildCurrentStepView(state.currentStep),
        ),
      ),
    );
  }
}

class WorkflowScreen extends ConsumerWidget {
  const WorkflowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      currentRoute: AppConstants.routeBookings,
      child: const WorkflowContent(),
    );
  }
}
