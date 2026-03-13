import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nannak_garage/controllers/workflow_controller.dart';
import '../../core/theme/color_palette.dart';
import '../../common/widgets/app_button.dart';

class EstimationScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSubmit;
  const EstimationScreen({super.key, this.onSubmit});

  @override
  ConsumerState<EstimationScreen> createState() => _EstimationScreenState();
}

class _EstimationScreenState extends ConsumerState<EstimationScreen> {
  final List<ServiceItem> _services = [
    ServiceItem(name: 'General Service', price: 150),
    ServiceItem(name: 'Oil Change', price: 45),
    ServiceItem(name: 'Tire Rotation', price: 30),
    ServiceItem(name: 'Brake Inspection', price: 40),
  ];

  final List<PartItem> _availableParts = [
    PartItem(name: 'Brake Pads', unitPrice: 60),
    PartItem(name: 'Air Filter', unitPrice: 25),
    PartItem(name: 'Spark Plugs', unitPrice: 18),
    PartItem(name: 'Headlight Bulb', unitPrice: 12),
  ];

  final List<LabourItem> _availableLabours = [
    LabourItem(description: 'Mechanic Hour', amount: 40),
    LabourItem(description: 'Diagnostic Check', amount: 25),
    LabourItem(description: 'Wheel Alignment', amount: 35),
    LabourItem(description: 'Painting Prep', amount: 55),
  ];

  final List<PartItem> _selectedParts = [];
  final List<LabourItem> _selectedLabours = [];

  void _toggleService(ServiceItem item, bool? selected) {
    setState(() {
      item.selected = selected ?? false;
    });
  }

  Future<void> _showPartsDialog() async {
    final preview = _selectedParts
        .map(
          (part) => PartItem(
            name: part.name,
            unitPrice: part.unitPrice,
            quantity: part.quantity,
          ),
        )
        .toList();
    PartItem current = _availableParts.first;
    int quantity = 1;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text('Add Spare Parts'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<PartItem>(
                        initialValue: current,
                        decoration: const InputDecoration(
                          labelText: 'Spare Part',
                        ),
                        items: _availableParts
                            .map(
                              (part) => DropdownMenuItem(
                                value: part,
                                child: Text(
                                  '${part.name} (₹${part.unitPrice.toStringAsFixed(2)})',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            dialogSetState(() {
                              current = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: '$quantity',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final parsed = int.tryParse(value) ?? 1;
                          dialogSetState(() {
                            quantity = parsed.clamp(1, 999);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            dialogSetState(() {
                              preview.add(
                                PartItem(
                                  name: current.name,
                                  unitPrice: current.unitPrice,
                                  quantity: quantity,
                                ),
                              );
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDialogTableHeader(
                        labels: const ['Part Name', 'Qty', 'Unit', 'Total'],
                      ),
                      if (preview.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('No spare parts added yet.'),
                        )
                      else
                        ...preview.map(
                          (part) => _buildDialogTableRow(
                            values: [
                              part.name,
                              '${part.quantity}',
                              '₹${part.unitPrice.toStringAsFixed(2)}',
                              '₹${part.totalPrice.toStringAsFixed(2)}',
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedParts
                        ..clear()
                        ..addAll(preview);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showLabourDialog() async {
    final preview = List<LabourItem>.from(_selectedLabours);
    LabourItem current = _availableLabours.first;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text('Add Labour Charges'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<LabourItem>(
                        initialValue: current,
                        decoration: const InputDecoration(
                          labelText: 'Labour Type',
                        ),
                        items: _availableLabours
                            .map(
                              (labour) => DropdownMenuItem(
                                value: labour,
                                child: Text(
                                  '${labour.description} (₹${labour.amount.toStringAsFixed(2)})',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            dialogSetState(() {
                              current = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            dialogSetState(() {
                              preview.add(
                                LabourItem(
                                  description: current.description,
                                  amount: current.amount,
                                ),
                              );
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add to Preview'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDialogTableHeader(
                        labels: const ['Description', 'Amount'],
                      ),
                      if (preview.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('No labour charges added yet.'),
                        )
                      else
                        ...preview.map(
                          (labour) => _buildDialogTableRow(
                            values: [
                              labour.description,
                              '₹${labour.amount.toStringAsFixed(2)}',
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedLabours
                        ..clear()
                        ..addAll(preview);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, {Widget? action}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: action == null
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            ?action,
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 2,
          color: ColorPalette.primaryColor,
        ),
      ],
    );
  }

  Widget _buildDialogTableHeader({required List<String> labels}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: ColorPalette.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: labels
            .map(
              (label) => Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDialogTableRow({required List<String> values}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorPalette.borderColor)),
      ),
      child: Row(
        children: values.map((value) => Expanded(child: Text(value))).toList(),
      ),
    );
  }

  Widget _buildMainTable({
    required List<String> headers,
    required List<TableRow> rows,
    required Map<int, TableColumnWidth> columnWidths,
  }) {
    return Table(
      columnWidths: columnWidths,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: ColorPalette.backgroundColor),
          children: headers
              .map(
                (header) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    header,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
        ...rows,
      ],
    );
  }

  double get _totalAmount {
    final servicesTotal = _services
        .where((service) => service.selected)
        .fold<double>(0, (sum, service) => sum + service.price);
    final partsTotal = _selectedParts.fold<double>(
      0,
      (sum, part) => sum + part.totalPrice,
    );
    final labourTotal = _selectedLabours.fold<double>(
      0,
      (sum, labour) => sum + labour.amount,
    );
    return servicesTotal + partsTotal + labourTotal;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(workflowControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Service Estimation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Service List'),
        const SizedBox(height: 16),
        ..._services.map(
          (service) => CheckboxListTile(
            value: service.selected,
            onChanged: (value) => _toggleService(service, value),
            title: Text(service.name),
            subtitle: Text('₹${service.price.toStringAsFixed(2)}'),
            activeColor: ColorPalette.primaryColor,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          'Spare Parts',
          action: TextButton.icon(
            onPressed: _showPartsDialog,
            icon: const Icon(
              Icons.add_circle_outline,
              color: ColorPalette.primaryColor,
            ),
            label: const Text(
              'Add Item',
              style: TextStyle(color: ColorPalette.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildMainTable(
          headers: const ['Part Name', 'Qty', 'Unit', 'Total'],
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(1.8),
            3: FlexColumnWidth(1.8),
          },
          rows: _selectedParts.isEmpty
              ? [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('No spare parts added'),
                      ),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                    ],
                  ),
                ]
              : _selectedParts
                    .map(
                      (part) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(part.name),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('${part.quantity}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              '₹${part.unitPrice.toStringAsFixed(2)}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              '₹${part.totalPrice.toStringAsFixed(2)}',
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          'Labour Charges',
          action: TextButton.icon(
            onPressed: _showLabourDialog,
            icon: const Icon(
              Icons.add_circle_outline,
              color: ColorPalette.primaryColor,
            ),
            label: const Text(
              'Add Item',
              style: TextStyle(color: ColorPalette.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildMainTable(
          headers: const ['Description', 'Amount'],
          columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(2)},
          rows: _selectedLabours.isEmpty
              ? [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('No labour charges added'),
                      ),
                      SizedBox(),
                    ],
                  ),
                ]
              : _selectedLabours
                    .map(
                      (labour) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(labour.description),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('₹${labour.amount.toStringAsFixed(2)}'),
                          ),
                        ],
                      ),
                    )
                    .toList(),
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(width: 16),
            Text(
              '₹${_totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: ColorPalette.primaryColor,
              ),
            ),
          ],
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
}

class ServiceItem {
  final String name;
  final double price;
  bool selected;

  ServiceItem({required this.name, required this.price, this.selected = false});
}

class PartItem {
  final String name;
  final double unitPrice;
  int quantity;

  PartItem({required this.name, required this.unitPrice, this.quantity = 1});

  double get totalPrice => unitPrice * quantity;
}

class LabourItem {
  final String description;
  final double amount;

  LabourItem({required this.description, required this.amount});
}
