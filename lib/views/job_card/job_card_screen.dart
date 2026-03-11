import 'package:flutter/material.dart';
import '../../common/widgets/common_textfield.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_dropdown.dart';
import '../../common/widgets/image_upload_widget.dart';
import '../../common/widgets/video_upload_widget.dart';
import '../../common/widgets/service_check_item.dart';
import '../../common/widgets/technician_dropdown.dart';
import '../estimation/estimation_screen.dart';
import '../../core/theme/color_palette.dart';

class JobCardScreen extends StatefulWidget {
  const JobCardScreen({super.key});

  @override
  State<JobCardScreen> createState() => _JobCardScreenState();
}

class _JobCardScreenState extends State<JobCardScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTech;
  final TextEditingController _dateController = TextEditingController();

  Map<String, bool> checklist = {
    'Engine Oil': false,
    'Brake Fluid': false,
    'Coolant Level': false,
    'Battery Health': false,
  };

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vehicle Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const CommonTextField(label: 'Vehicle Brand'),
                  const CommonTextField(label: 'Vehicle Model'),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CommonTextField(
                        controller: _dateController,
                        label: 'Registration Date',
                      ),
                    ),
                  ),
                  const CommonTextField(label: 'Engine Number'),
                  const CommonTextField(label: 'Chassis Number'),
                  const CommonTextField(label: 'Fitness'),
                  CommonDropdown<String>(
                    label: 'Vehicle Class',
                    value: null,
                    items: const [
                      DropdownMenuItem(value: 'LMV', child: Text('LMV')),
                      DropdownMenuItem(value: 'MCWG', child: Text('MCWG')),
                    ],
                    onChanged: (val) {},
                  ),
                  CommonDropdown<String>(
                    label: 'Fuel Type',
                    value: null,
                    items: const [
                      DropdownMenuItem(value: 'Petrol', child: Text('Petrol')),
                      DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
                      DropdownMenuItem(value: 'EV', child: Text('EV')),
                    ],
                    onChanged: (val) {},
                  ),
                  const CommonTextField(
                    label: 'Insurance Expiry Date',
                    hint: 'YYYY-MM-DD',
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Uploads',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ImageUploadWidget(
                          label: 'Front View',
                          onImageSelected: (_) {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ImageUploadWidget(
                          label: 'Back View',
                          onImageSelected: (_) {},
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ImageUploadWidget(
                          label: 'Left View',
                          onImageSelected: (_) {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ImageUploadWidget(
                          label: 'Right View',
                          onImageSelected: (_) {},
                        ),
                      ),
                    ],
                  ),
                  VideoUploadWidget(
                    label: 'Vehicle Video Capture',
                    onVideoSelected: (_) {},
                  ),
                  VideoUploadWidget(
                    label: 'Damage Video Capture',
                    onVideoSelected: (_) {},
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Inspection Checklist',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  ...checklist.keys.map((key) {
                    return ServiceCheckItem(
                      title: key,
                      isChecked: checklist[key]!,
                      onChanged: (val) {
                        setState(() {
                          checklist[key] = val ?? false;
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 32),
                  const CommonTextField(
                    label: 'Customer Service Request',
                    maxLines: 3,
                  ),
                  const CommonTextField(label: 'Advisor Request', maxLines: 3),

                  const SizedBox(height: 24),
                  TechnicianDropdown(
                    selectedTechnician: _selectedTech,
                    onChanged: (val) {
                      setState(() {
                        _selectedTech = val;
                      });
                    },
                  ),

                  const SizedBox(height: 32),
                  CommonButton(
                    text: 'Save & Next Calculation',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EstimationScreen(),
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
