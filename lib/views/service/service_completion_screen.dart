import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../controllers/workflow_controller.dart';
import '../main/main_screen.dart';

class ServiceCompletionScreen extends ConsumerStatefulWidget {
  const ServiceCompletionScreen({super.key});

  @override
  ConsumerState<ServiceCompletionScreen> createState() =>
      _ServiceCompletionScreenState();
}

class _ServiceCompletionScreenState
    extends ConsumerState<ServiceCompletionScreen> {
  final List<String> _services = [
    'General Service',
    'Oil Change',
    'Brake Pad Replacement',
    'Wheel Alignment',
  ];

  final Map<String, bool> _completedServices = {};
  final Map<String, String> _warningReasons = {};
  bool _selectAll = false;
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var service in _services) {
      _completedServices[service] = false;
    }
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  void _toggleSelectAll(bool? val) {
    if (val == null) return;
    setState(() {
      _selectAll = val;
      for (var service in _services) {
        _completedServices[service] = val;
      }
    });
  }

  void _checkSelectAllStatus() {
    bool allSelected = _services.every((s) => _completedServices[s] == true);
    if (_selectAll != allSelected) {
      setState(() {
        _selectAll = allSelected;
      });
    }
  }

  void _showWarningDialog(String service) {
    final reasonController = TextEditingController(
      text: _warningReasons[service] ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Report Issue: $service',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please enter the reason for this warning:'),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'E.g., parts pending...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: ColorPalette.textSecondary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (reasonController.text.trim().isNotEmpty) {
                      _warningReasons[service] = reasonController.text.trim();
                    } else {
                      _warningReasons.remove(service);
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showFinalSubmitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Submit Service Completion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter final remarks (optional):'),
                const SizedBox(height: 16),
                TextField(
                  controller: _remarkController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Any closing notes...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: ColorPalette.textSecondary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Move to Quality Check
                  ref.read(workflowControllerProvider.notifier).nextStep();
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(workflowControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Service Completion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
            ),
          ],
        ),
        const Divider(color: ColorPalette.primaryColor,),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorPalette.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorPalette.borderColor),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _selectAll,
                onChanged: _toggleSelectAll,
                activeColor: ColorPalette.primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                'Select All Services',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorPalette.borderColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _services.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final service = _services[index];
              final isCompleted = _completedServices[service] ?? false;
              final hasWarning = _warningReasons.containsKey(service);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    service,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color:
                          isCompleted
                              ? ColorPalette.textSecondary
                              : ColorPalette.textPrimary,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle:
                      hasWarning
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Warning: ${_warningReasons[service]}',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                          : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Report Issue',
                        icon: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                        ),
                        onPressed: () => _showWarningDialog(service),
                      ),
                      const SizedBox(width: 8),
                      Checkbox(
                        value: isCompleted,
                        onChanged: (val) {
                          setState(() {
                            _completedServices[service] = val ?? false;
                            _checkSelectAllStatus();
                          });
                        },
                        activeColor: ColorPalette.primaryColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: SizedBox(
            width: 250,
            child: AppButton(
              text: 'Submit',
              onPressed: _showFinalSubmitDialog,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
