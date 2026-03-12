import 'package:flutter/material.dart';
import '../../core/theme/color_palette.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          color: ColorPalette.textSecondary,
        ),
        const SizedBox(width: 8),
        ...List.generate(totalPages, (index) {
          final page = index + 1;
          final isSelected = page == currentPage;
          return InkWell(
            onTap: () => onPageChanged(page),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? ColorPalette.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? ColorPalette.primaryColor : ColorPalette.borderColor,
                ),
              ),
              child: Center(
                child: Text(
                  '$page',
                  style: TextStyle(
                    color: isSelected ? Colors.white : ColorPalette.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
          color: ColorPalette.textSecondary,
        ),
      ],
    );
  }
}
