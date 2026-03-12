import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_palette.dart';

class StepProgressWidget extends StatelessWidget {
  final String currentStep;

  const StepProgressWidget({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = AppConstants.workflowSteps;
    final currentIndex = steps.indexOf(currentStep);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentIndex;
          final isActive = index == currentIndex;
          final stepName = steps[index];

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive || isCompleted
                              ? ColorPalette.primaryColor
                              : ColorPalette.backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive || isCompleted
                                ? ColorPalette.primaryColor
                                : ColorPalette.borderColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive || isCompleted
                                        ? Colors.white
                                        : ColorPalette.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stepName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive
                              ? ColorPalette.primaryColor
                              : ColorPalette.textSecondary,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted
                          ? ColorPalette.primaryColor
                          : ColorPalette.borderColor,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
