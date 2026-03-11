import 'package:flutter/material.dart';
import '../../common/widgets/common_textfield.dart';
import '../../common/widgets/common_button.dart';
import '../../core/theme/color_palette.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  String _paymentMethod = 'Cash';
  final double _totalAmount = 150.0;
  double _discount = 0.0;
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _discountController.addListener(() {
      setState(() {
        _discount = double.tryParse(_discountController.text) ?? 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double finalAmount = _totalAmount - _discount;

    return Scaffold(
      appBar: AppBar(title: const Text('Billing & Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(finalAmount),
                const SizedBox(height: 32),
                const Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                CommonTextField(
                  controller: _discountController,
                  label: 'Discount Amount',
                  keyboardType: TextInputType.number,
                ),
                const CommonTextField(label: 'Narration', maxLines: 2),

                const SizedBox(height: 24),
                const Text(
                  'Payment Method',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 16,
                  children: ['Cash', 'Card', 'UPI', 'Online'].map((method) {
                    return ChoiceChip(
                      label: Text(method),
                      selected: _paymentMethod == method,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _paymentMethod = method;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),
                CommonButton(
                  text: 'Generate Invoice & Finish',
                  onPressed: () {
                    _showSuccessDialog();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double finalAmount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildSummaryRow('Customer', 'John Doe'),
            _buildSummaryRow('Vehicle', 'Toyota Camry (ABC-1234)'),
            _buildSummaryRow(
              'Services completed',
              'Oil Change, Wheel Alignment',
            ),
            _buildSummaryRow(
              'Quality Check',
              'PASS',
              valueColor: ColorPalette.successColor,
            ),
            const Divider(),
            _buildSummaryRow(
              'Total Labor & Parts',
              '\$${_totalAmount.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'Discount',
              '-\$${_discount.toStringAsFixed(2)}',
              valueColor: ColorPalette.errorColor,
            ),
            const Divider(),
            _buildSummaryRow(
              'Grand Total',
              '\$${finalAmount.toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: ColorPalette.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? ColorPalette.textPrimary,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: ColorPalette.successColor,
              size: 64,
            ),
            SizedBox(height: 16),
            Text('Invoice generated successfully! Job card closed.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
