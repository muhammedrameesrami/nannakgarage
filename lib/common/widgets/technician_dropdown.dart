import 'package:flutter/material.dart';
import 'common_dropdown.dart';

class TechnicianDropdown extends StatelessWidget {
  final String? selectedTechnician;
  final ValueChanged<String?> onChanged;

  const TechnicianDropdown({
    Key? key,
    required this.selectedTechnician,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDropdown<String>(
      label: 'Assign Technician',
      value: selectedTechnician,
      items: const [
        DropdownMenuItem(value: 'Tech 1', child: Text('Technician 1')),
        DropdownMenuItem(value: 'Tech 2', child: Text('Technician 2')),
        DropdownMenuItem(value: 'Tech 3', child: Text('Technician 3')),
      ],
      onChanged: onChanged,
    );
  }
}
