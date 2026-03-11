import 'package:flutter/material.dart';
import '../../common/widgets/common_textfield.dart';
import '../../common/widgets/common_button.dart';
import '../quality_check/quality_check_screen.dart';
import '../../core/theme/color_palette.dart';

class ServiceUpdateScreen extends StatefulWidget {
  const ServiceUpdateScreen({super.key});

  @override
  State<ServiceUpdateScreen> createState() => _ServiceUpdateScreenState();
}

class _ServiceUpdateScreenState extends State<ServiceUpdateScreen> {
  final Map<String, bool> _services = {
    'Oil Change': false,
    'Wheel Alignment': false,
  };
  final Map<String, TextEditingController> _reasonControllers = {
    'Oil Change': TextEditingController(),
    'Wheel Alignment': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Completion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update Service Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                ..._services.keys.map((service) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _services[service],
                                onChanged: (val) {
                                  setState(() {
                                    _services[service] = val!;
                                  });
                                },
                              ),
                              const Text('Completed'),
                              const SizedBox(width: 16),
                              Radio<bool>(
                                value: false,
                                groupValue: _services[service],
                                onChanged: (val) {
                                  setState(() {
                                    _services[service] = val!;
                                  });
                                },
                              ),
                              const Text('Not Completed'),
                            ],
                          ),
                          if (_services[service] == false)
                            CommonTextField(
                              controller: _reasonControllers[service],
                              label: 'Reason for not completing',
                            ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),
                CommonButton(
                  text: 'Submit to Quality Check',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QualityCheckScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
