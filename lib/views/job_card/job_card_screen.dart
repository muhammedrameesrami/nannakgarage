import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_textfield.dart';
import '../../common/widgets/app_dropdown.dart';
import '../../controllers/workflow_controller.dart';

class JobCardScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSubmit;
  const JobCardScreen({super.key, this.onSubmit});

  @override
  ConsumerState<JobCardScreen> createState() => _JobCardScreenState();
}

class _JobCardScreenState extends ConsumerState<JobCardScreen> {
  static const List<String> _technicians = [
    'Afsal',
    'Riyas',
    'Shameer',
    'Nithin',
    'Suhail',
  ];
  static const List<String> _inspectionItems = [
    'Brakes',
    'Engine',
    'Lights',
    'Battery',
    'Suspension',
  ];

  String? _selectedTechnician;
  late final Map<String, bool> _inspectionSelections = {
    for (final item in _inspectionItems) item: false,
  };

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(workflowControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Job Card',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                label: 'Technician Assignment',
                hint: 'Select Technician',
                value: _selectedTechnician,
                items: _technicians
                    .map(
                      (technician) => DropdownMenuItem<String>(
                        value: technician,
                        child: Text(technician),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTechnician = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 32),
        const AppTextField(
          label: 'Customer Complaints',
          hint: 'Enter customer issues',
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        const AppTextField(
          label: 'Advisor Notes',
          hint: 'Enter advisor notes',
          maxLines: 4,
        ),
        const SizedBox(height: 32),
        Text(
          'Inspection Checklist',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: _inspectionItems
              .map((item) => _buildChecklistItem(item))
              .toList(),
        ),
        const SizedBox(height: 32),
        Center(
          child: AppButton(
            text: 'Save',
            onPressed: () {
              if (widget.onSubmit != null) {
                widget.onSubmit!();
              } else {
                notifier.nextStep();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _inspectionSelections[title] ?? false,
          onChanged: (val) {
            setState(() {
              _inspectionSelections[title] = val ?? false;
            });
          },
          activeColor: ColorPalette.primaryColor,
        ),
        Text(title),
      ],
    );
  }
}
