import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Navigation controls bar for the WebView screen
class NavigationControls extends StatelessWidget {
  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onHome;
  final VoidCallback onRefresh;
  final VoidCallback onToggleFullscreen;
  final bool isFullscreen;

  const NavigationControls({
    super.key,
    required this.canGoBack,
    required this.canGoForward,
    required this.onBack,
    required this.onForward,
    required this.onHome,
    required this.onRefresh,
    required this.onToggleFullscreen,
    this.isFullscreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(
            icon: Icons.arrow_back_ios_new,
            label: AppStrings.back,
            onPressed: canGoBack ? onBack : null,
          ),
          _buildNavButton(
            icon: Icons.arrow_forward_ios,
            label: AppStrings.forward,
            onPressed: canGoForward ? onForward : null,
          ),
          _buildNavButton(
            icon: Icons.home_outlined,
            label: AppStrings.homePage,
            onPressed: onHome,
          ),
          _buildNavButton(
            icon: Icons.refresh,
            label: AppStrings.refresh,
            onPressed: onRefresh,
          ),
          _buildNavButton(
            icon: isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
            label: isFullscreen ? AppStrings.exitFullscreen : AppStrings.enterFullscreen,
            onPressed: onToggleFullscreen,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isEnabled ? AppColors.onSurface : AppColors.subtle,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isEnabled ? AppColors.onSurface : AppColors.subtle,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}