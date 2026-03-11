import 'package:flutter/material.dart';
import '../../common/widgets/common_textfield.dart';
import '../../common/widgets/common_button.dart';
import '../billing/billing_screen.dart';
import '../../core/theme/color_palette.dart';

class QualityCheckScreen extends StatefulWidget {
  const QualityCheckScreen({super.key});

  @override
  State<QualityCheckScreen> createState() => _QualityCheckScreenState();
}

class _QualityCheckScreenState extends State<QualityCheckScreen> {
  final Map<String, bool> _checklist = {
    'Brakes Working': true,
    'Lights Functional': true,
    'Tire Pressure Checked': true,
    'Engine Sound Normal': true,
    'No Fluid Leaks': true,
  };

  String? _result;
  final TextEditingController _failReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quality Check')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quality Verification',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                ..._checklist.keys.map((item) {
                  return CheckboxListTile(
                    title: Text(item),
                    value: _checklist[item],
                    onChanged: (val) {
                      setState(() {
                        _checklist[item] = val ?? false;
                      });
                    },
                  );
                }),

                const SizedBox(height: 32),
                const Text(
                  'Overall Result',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Pass',
                      groupValue: _result,
                      onChanged: (val) {
                        setState(() {
                          _result = val;
                        });
                      },
                    ),
                    const Text(
                      'Pass',
                      style: TextStyle(
                        color: ColorPalette.successColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Radio<String>(
                      value: 'Fail',
                      groupValue: _result,
                      onChanged: (val) {
                        setState(() {
                          _result = val;
                        });
                      },
                    ),
                    const Text(
                      'Fail',
                      style: TextStyle(
                        color: ColorPalette.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                if (_result == 'Fail')
                  CommonTextField(
                    controller: _failReasonController,
                    label: 'Reason for failure',
                    maxLines: 3,
                  ),

                const SizedBox(height: 32),
                CommonButton(
                  text: 'Submit & Proceed to Billing',
                  onPressed: _result == null
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BillingScreen(),
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
