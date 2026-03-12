import 'package:flutter/material.dart';
import 'dart:math';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Base design dimensions (Desktop - 1440x900)
  static const double baseWidth = 1440;
  static const double baseHeight = 900;

  /// Scaled width based on design px
  double w(double px) => (screenWidth / baseWidth) * px;

  /// Scaled height based on design px
  double h(double px) => (screenHeight / baseHeight) * px;

  /// Scaled Font Size (Scales with width but with a minimum limit)
  double sp(double px) {
    double scale = screenWidth / baseWidth;
    // For mobile, don't let it scale down linearly too much
    if (screenWidth < 850) {
      // On mobile (e.g. 360), scale would be 360/1440 = 0.25
      // 32px would become 8px. Too small.
      // We use a different scaling factor for mobile or clamp it.
      return max(px * 0.7, px * scale * 1.5);
    }
    return px * scale;
  }

  /// Clamped font size
  double csp(double px, {double? minSize, double? maxSize}) {
    double size = sp(px);
    if (minSize != null && size < minSize) return minSize;
    if (maxSize != null && size > maxSize) return maxSize;
    return size;
  }
}
