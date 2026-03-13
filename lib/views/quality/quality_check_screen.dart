import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../controllers/workflow_controller.dart';
import '../main/main_screen.dart';

class QualityCheckScreen extends ConsumerStatefulWidget {
  const QualityCheckScreen({super.key});

  @override
  ConsumerState<QualityCheckScreen> createState() => _QualityCheckScreenState();
}

class _QualityCheckScreenState extends ConsumerState<QualityCheckScreen> {
  final List<String> _services = [
    'General Service',
    'Oil Change',
    'Brake Pad Replacement',
    'Wheel Alignment',
  ];

  // Map to hold checked status. By default all are true
  final Map<String, bool> _checkedServices = {};
  
  // Map to hold remarks entered when unchecking an item
  final Map<String, String> _uncheckRemarks = {};

  // Example of existing warnings from the technician step
  // They should be visible. In a real app, this comes from state.
  final Map<String, String> _technicianWarnings = {
    'Brake Pad Replacement': 'Pending parts availability from warehouse.',
  };

  @override
  void initState() {
    super.initState();
    for (var service in _services) {
      _checkedServices[service] = true;
    }
  }

  void _showUncheckWarningDialog(String service) {
    final reasonController = TextEditingController(
      text: _uncheckRemarks[service] ?? '',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Quality Issue: $service',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please enter the reason for failing this check:'),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // If they cancel, revert the checkbox to true
                  setState(() {
                    _checkedServices[service] = true;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: ColorPalette.textSecondary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.statusError,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (reasonController.text.trim().isNotEmpty) {
                      _uncheckRemarks[service] = reasonController.text.trim();
                    } else {
                      _uncheckRemarks[service] = 'Failed quality check.';
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Submit Option'),
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
       
        const Text(
          'Completed Services Checklist',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Divider(color: ColorPalette.primaryColor,),
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
              final isChecked = _checkedServices[service] ?? true;
              final hasTechnicianWarning = _technicianWarnings.containsKey(
                service,
              );
              final hasQCUncheckRemark = _uncheckRemarks.containsKey(service) &&
                  !isChecked;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    service,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasTechnicianWarning)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Technician Note: ${_technicianWarnings[service]}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hasQCUncheckRemark)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 16,
                                color: ColorPalette.statusError,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'QC Failed: ${_uncheckRemarks[service]}',
                                  style: const TextStyle(
                                    color: ColorPalette.statusError,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  trailing: Checkbox(
                    value: isChecked,
                    activeColor: ColorPalette.primaryColor,
                    onChanged: (val) {
                      final newValue = val ?? false;
                      setState(() {
                        _checkedServices[service] = newValue;
                      });

                      if (!newValue) {
                        // If unchecking, show the warning dialog
                        _showUncheckWarningDialog(service);
                      } else {
                        // If checking again, clear any QC remarks
                        setState(() {
                          _uncheckRemarks.remove(service);
                        });
                      }
                    },
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
              text: 'Submit Check',
              onPressed: () {
                notifier.nextStep();
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
