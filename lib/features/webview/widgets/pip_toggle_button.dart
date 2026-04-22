import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// PiP toggle button widget for the WebView screen
class PiPToggleButton extends StatelessWidget {
  final bool isPiPActive;
  final VoidCallback onToggle;

  const PiPToggleButton({
    super.key,
    required this.isPiPActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: onToggle,
      backgroundColor: isPiPActive ? AppColors.highlight : AppColors.accent,
      tooltip: isPiPActive ? 'Exit PiP' : AppStrings.togglePip,
      child: Icon(
        isPiPActive ? Icons.picture_in_picture_alt : Icons.picture_in_picture_alt_outlined,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}