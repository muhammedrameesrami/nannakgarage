import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';

import '../../common/widgets/status_badge.dart';
import '../../controllers/booking_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';
import '../../core/utils/responsive.dart';
import '../../common/widgets/app_button.dart';
import '../../models/booking_model.dart';

class SalesReportContent extends ConsumerStatefulWidget {
  const SalesReportContent({super.key});

  @override
  ConsumerState<SalesReportContent> createState() => _SalesReportContentState();
}

class _SalesReportContentState extends ConsumerState<SalesReportContent> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart
              ? (_startDate ?? DateTime.now())
              : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorPalette.primaryColor,
              onPrimary: Colors.white,
              onSurface: ColorPalette.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Ensure end date is not before start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _exportToExcel(List<BookingModel> bookings) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sales Report'];
    excel.setDefaultSheet('Sales Report');

    // Remove the default "Sheet1"
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Add Headers
    sheetObject.appendRow([
      TextCellValue('Booking Number'),
      TextCellValue('Date'),
      TextCellValue('Vehicle Number'),
      TextCellValue('Customer'),
      TextCellValue('Service Type'),
      TextCellValue('Status'),
      TextCellValue('Amount (INR)'),
    ]);

    // Add Data
    for (var booking in bookings) {
      sheetObject.appendRow([
        TextCellValue(booking.bookingNumber),
        TextCellValue(DateFormat('dd MMM yyyy').format(booking.createdAt)),
        TextCellValue(booking.vehicle.number),
        TextCellValue(booking.customer.name),
        TextCellValue(booking.serviceType),
        TextCellValue(booking.status),
        DoubleCellValue(booking.finalCost ?? 0.0),
      ]);
    }

    // Save File
    var fileBytes = excel.encode();
    if (fileBytes != null) {
      String fileName =
          'Sales_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}';
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(fileBytes),
        // ext: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingControllerProvider);
    
    // Filter by gate exit status AND date range (if set)
    final gateExitBookings = state.bookings.where((b) {
      bool isGateExit = b.status == AppConstants.statusGateExit;
      if (!isGateExit) return false;

      DateTime bDate = DateTime(
        b.createdAt.year,
        b.createdAt.month,
        b.createdAt.day,
      );

      if (_startDate != null) {
        DateTime sDate = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
        );
        if (bDate.isBefore(sDate)) return false;
      }

      if (_endDate != null) {
        DateTime eDate = DateTime(
          _endDate!.year,
          _endDate!.month,
          _endDate!.day,
        );
        if (bDate.isAfter(eDate)) return false;
      }

      return true;
    }).toList();

    // Sort by date descending
    gateExitBookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final totalAmount = gateExitBookings.fold<double>(
      0,
      (sum, b) => sum + (b.finalCost ?? 0),
    );

    return Padding(
      padding: EdgeInsets.all(context.w(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Report',
                style: TextStyle(
                  fontSize: context.sp(24),
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
              AppButton(
                text: 'Download Excel',
                icon: Icons.download_rounded,
                onPressed: () => _exportToExcel(gateExitBookings),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          
          // Filters
          Wrap(
            spacing: context.w(16),
            runSpacing: context.h(16),
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildDateSelector(
                context,
                label: 'Start Date',
                date: _startDate,
                onTap: () => _selectDate(context, true),
              ),
              _buildDateSelector(
                context,
                label: 'Due Date',
                date: _endDate,
                onTap: () => _selectDate(context, false),
              ),
              if (_startDate != null || _endDate != null)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                    });
                  },
                  icon: const Icon(Icons.clear, size: 18),
                  label: const Text('Clear Filters'),
                  style: TextButton.styleFrom(
                    foregroundColor: ColorPalette.statusError,
                  ),
                ),
            ],
          ),
          
          SizedBox(height: context.h(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.w(20)),
            decoration: BoxDecoration(
              color: ColorPalette.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(
              //   color: ColorPalette.primaryColor.withValues(alpha: 0.3),
              // ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: ColorPalette.primaryColor,
                  size: 32,
                ),
                SizedBox(width: context.w(16)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtered Sales Amount',
                      style: TextStyle(
                        fontSize: context.sp(13),
                        color: ColorPalette.textSecondary,
                      ),
                    ),
                    Text(
                      '₹ ${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: context.sp(24),
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.primaryColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Filtered Vehicles',
                      style: TextStyle(
                        fontSize: context.sp(13),
                        color: ColorPalette.textSecondary,
                      ),
                    ),
                    Text(
                      '${gateExitBookings.length}',
                      style: TextStyle(
                        fontSize: context.sp(24),
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(20)),
          Expanded(
            child: Card(
              child:
                  state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(24),
                              vertical: context.h(16),
                            ),
                            child: Row(
                              children: [
                                _headerCell(context, 'Date', 1),
                                _headerCell(context, 'Vehicle Number', 2),
                                _headerCell(context, 'Customer', 2),
                                _headerCell(context, 'Service Type', 2),
                                _headerCell(context, 'Status', 1),
                                _headerCell(context, 'Amount', 1),
                              ],
                            ),
                          ),
                          const Divider(color: ColorPalette.primaryColor),
                          Expanded(
                            child:
                                gateExitBookings.isEmpty
                                    ? Center(
                                      child: Text(
                                        'No gate exit vehicles found.',
                                        style: TextStyle(
                                          color: ColorPalette.textSecondary,
                                          fontSize: context.sp(14),
                                        ),
                                      ),
                                    )
                                    : ListView.separated(
                                      itemCount: gateExitBookings.length,
                                      separatorBuilder:
                                          (_, index) => const Divider(),
                                      itemBuilder: (context, index) {
                                        final booking = gateExitBookings[index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.w(24),
                                            vertical: context.h(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  DateFormat('dd MMM yyyy')
                                                      .format(booking.createdAt),
                                                  style: TextStyle(
                                                    fontSize: context.sp(13),
                                                    color: ColorPalette
                                                        .textSecondary,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  booking.vehicle.number,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: context.sp(14),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  booking.customer.name,
                                                  style: TextStyle(
                                                    fontSize: context.sp(14),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  booking.serviceType,
                                                  style: TextStyle(
                                                    fontSize: context.sp(14),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: StatusBadge(
                                                    status: booking.status,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  '₹ ${(booking.finalCost ?? 0).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: context.sp(14),
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        ColorPalette
                                                            .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // border: Border.all(color: ColorPalette.borderColor),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: ColorPalette.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              date != null ? DateFormat('dd MMM yyyy').format(date) : label,
              style: TextStyle(
                color:
                    date != null
                        ? ColorPalette.textPrimary
                        : ColorPalette.textSecondary,
                fontSize: 14,
                fontWeight: date != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(BuildContext context, String title, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: ColorPalette.textSecondary,
          fontSize: context.sp(14),
        ),
      ),
    );
  }
}
