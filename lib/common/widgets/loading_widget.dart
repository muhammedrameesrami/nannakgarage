import 'package:flutter/material.dart';
import '../../core/theme/color_palette.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
      ),
    );
  }
}
