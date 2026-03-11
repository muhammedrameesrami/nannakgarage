import 'package:flutter/material.dart';
import '../../common/widgets/common_textfield.dart';
import '../../common/widgets/common_button.dart';
import '../service_update/service_update_screen.dart';
import '../../core/theme/color_palette.dart';

class EstimationScreen extends StatelessWidget {
  const EstimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estimation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                const ListTile(
                  title: Text('Oil Change'),
                  trailing: Text('\$50'),
                ),
                const ListTile(
                  title: Text('Wheel Alignment'),
                  trailing: Text('\$30'),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Insurance Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                const CommonTextField(label: 'Insurance Provider'),
                const CommonTextField(label: 'Policy Number'),

                const SizedBox(height: 24),
                const Text(
                  'Spare Parts Section',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                const CommonTextField(label: 'Select Spare Part'),
                const CommonTextField(
                  label: 'Price',
                  keyboardType: TextInputType.number,
                ),
                const CommonTextField(
                  label: 'Quantity',
                  keyboardType: TextInputType.number,
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Spare Part'),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Labour Section',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                const CommonTextField(label: 'Labour Description'),
                const CommonTextField(
                  label: 'Labour Charge',
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: ColorPalette.primaryColor,
                        ),
                        onPressed: () {},
                        child: const Text('Print Estimation'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonButton(
                        text: 'Next',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ServiceUpdateScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
