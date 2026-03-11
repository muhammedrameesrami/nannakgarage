import 'package:flutter/material.dart';
import '../../common/widgets/common_textfield.dart';
import '../../common/widgets/common_button.dart';
import '../job_card/job_card_screen.dart';

class GateEntryScreen extends StatefulWidget {
  const GateEntryScreen({super.key});

  @override
  State<GateEntryScreen> createState() => _GateEntryScreenState();
}

class _GateEntryScreenState extends State<GateEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gate Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vehicle Entry',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const CommonTextField(label: 'Customer Name'),
                  const CommonTextField(
                    label: 'Customer Phone',
                    keyboardType: TextInputType.phone,
                  ),
                  const CommonTextField(label: 'Area Name'),
                  const CommonTextField(label: 'Vehicle Number'),
                  const CommonTextField(
                    label: 'KM Driven',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  CommonButton(
                    text: 'Save & Next',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JobCardScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
