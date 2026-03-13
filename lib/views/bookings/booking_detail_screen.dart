import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/status_badge.dart';
import '../../models/booking_model.dart';
import '../layout/app_layout.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicle = booking.vehicle;
    final customer = booking.customer;

    return AppLayout(
      currentRoute: AppConstants.routeBookings,
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed: Back button + heading
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: ColorPalette.textPrimary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${vehicle.number} - ${vehicle.displayName}',
                    style: TextStyle(
                      fontSize: context.sp(24),
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(24)),

            // Scrollable: detail cards
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle Details
                    _buildSectionCard(
                      context,
                      title: 'Vehicle Details',
                      icon: Icons.directions_car_outlined,
                      rows: [
                        _row('Brand', vehicle.brand),
                        _row('Model', vehicle.model),
                        _row('Vehicle Number', vehicle.number),
                        _row('Chassis Number', vehicle.chassisNumber ?? '-'),
                        _row('Engine Number', vehicle.engineNumber ?? '-'),
                        _row('Registration Date', vehicle.registrationDate ?? '-'),
                        _row('Fuel', vehicle.fuel ?? '-'),
                        _row('KM Driven', vehicle.kmDriven),
                      ],
                    ),
                    SizedBox(height: context.h(20)),

                    // Customer Details
                    _buildSectionCard(
                      context,
                      title: 'Customer Details',
                      icon: Icons.person_outline,
                      rows: [
                        _row('Name', customer.name),
                        _row('Phone', customer.phone),
                        _row('Location', customer.address ?? '-'),
                      ],
                    ),
                    SizedBox(height: context.h(20)),

                    // Service Information
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(context.w(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.build_outlined, size: 20, color: ColorPalette.primaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Service Information',
                                  style: TextStyle(
                                    fontSize: context.sp(16),
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalette.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: ColorPalette.primaryColor,),
                            _buildTextRow(context, 'Service Type', booking.serviceType),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: context.sp(14),
                                        color: ColorPalette.textSecondary,
                                      ),
                                    ),
                                  ),
                                  StatusBadge(status: booking.status),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MapEntry<String, String> _row(String label, String value) => MapEntry(label, value);

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<MapEntry<String, String>> rows,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: ColorPalette.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.textPrimary,
                  ),
                ),
              ],
            ),
            const Divider(color: ColorPalette.primaryColor,),
            ...rows.map((r) => _buildTextRow(context, r.key, r.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: TextStyle(
                fontSize: context.sp(14),
                color: ColorPalette.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: context.sp(14),
                fontWeight: FontWeight.w600,
                color: ColorPalette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
