import 'package:flutter/material.dart';
import '../../common/widgets/app_button.dart';
import '../../core/theme/color_palette.dart';

class VehicleInventoryScreen extends StatefulWidget {
  final String ownerName;
  final String brand;
  final String model;
  final String engineNumber;
  final String chassisNumber;
  final String drivenKm;

  const VehicleInventoryScreen({
    super.key,
    required this.ownerName,
    required this.brand,
    required this.model,
    required this.engineNumber,
    required this.chassisNumber,
    required this.drivenKm,
  });

  @override
  State<VehicleInventoryScreen> createState() => _VehicleInventoryScreenState();
}

class _VehicleInventoryScreenState extends State<VehicleInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ownerNameController;
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _engineNumberController;
  late final TextEditingController _chassisNumberController;
  late final TextEditingController _fitnessController;
  late final TextEditingController _vehicleClassController;
  late final TextEditingController _drivenKmController;

  late DateTime _registrationDate;
  late DateTime _insuranceExpirationDate;
  String? _fuelType = 'Petrol';

  @override
  void initState() {
    super.initState();
    _ownerNameController = TextEditingController(text: widget.ownerName);
    _brandController = TextEditingController(text: widget.brand);
    _modelController = TextEditingController(text: widget.model);
    _engineNumberController = TextEditingController(text: widget.engineNumber);
    _chassisNumberController = TextEditingController(
      text: widget.chassisNumber,
    );
    _fitnessController = TextEditingController();
    _vehicleClassController = TextEditingController();
    _drivenKmController = TextEditingController(text: widget.drivenKm);
    _registrationDate = DateTime.now();
    _insuranceExpirationDate = DateTime.now();
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _engineNumberController.dispose();
    _chassisNumberController.dispose();
    _fitnessController.dispose();
    _vehicleClassController.dispose();
    _drivenKmController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  InputDecoration _inputDecoration(String label, {bool required = false}) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: ColorPalette.borderColor.withValues(alpha: 0.8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.primaryColor),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, required: required),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDateField(
    String label,
    DateTime value, {
    bool required = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: _inputDecoration(label, required: required),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDate(value)),
            const Icon(Icons.calendar_today_outlined, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Inventory',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              SizedBox(
                width: 320,
                child: _buildTextField(
                  'Owner Name',
                  _ownerNameController,
                  required: true,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildDateField(
                  'Registration Date',
                  _registrationDate,
                  onTap: () => _pickDate(
                    initialDate: _registrationDate,
                    onSelected: (date) =>
                        setState(() => _registrationDate = date),
                  ),
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildTextField(
                  'Brand',
                  _brandController,
                  required: true,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildTextField(
                  'Vehicle Name',
                  _modelController,
                  required: true,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildTextField(
                  'Engine Number',
                  _engineNumberController,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildTextField(
                  'Chassis Number',
                  _chassisNumberController,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildTextField('Fitness', _fitnessController),
              ),
              SizedBox(
                width: 320,
                child: _buildTextField(
                  'Vehicle Class',
                  _vehicleClassController,
                ),
              ),
              SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  initialValue: _fuelType,
                  decoration: _inputDecoration('Fuel Type', required: true),
                  items: const ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                      .map(
                        (fuel) =>
                            DropdownMenuItem(value: fuel, child: Text(fuel)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _fuelType = value),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Fuel Type is required'
                      : null,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildDateField(
                  'Insurance Expiration',
                  _insuranceExpirationDate,
                  onTap: () => _pickDate(
                    initialDate: _insuranceExpirationDate,
                    onSelected: (date) =>
                        setState(() => _insuranceExpirationDate = date),
                  ),
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildTextField(
                  'Driven Km',
                  _drivenKmController,
                  required: true,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Save Inventory',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Inventory details saved locally'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
