import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Quick actions grid (2x2) for the Dashboard screen
class QuickLinksGrid extends StatelessWidget {
  final VoidCallback onOpenYouTube;
  final VoidCallback onTogglePiP;
  final VoidCallback onLockScreenPlay;
  final VoidCallback onClearCache;

  const QuickLinksGrid({
    super.key,
    required this.onOpenYouTube,
    required this.onTogglePiP,
    required this.onLockScreenPlay,
    required this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildQuickAction(
          icon: Icons.play_circle_outline,
          label: AppStrings.openYouTube,
          color: AppColors.highlight,
          onTap: onOpenYouTube,
        ),
        _buildQuickAction(
          icon: Icons.picture_in_picture_alt_outlined,
          label: AppStrings.togglePip,
          color: AppColors.accent,
          onTap: onTogglePiP,
        ),
        _buildQuickAction(
          icon: Icons.lock_outline,
          label: AppStrings.lockScreenPlay,
          color: AppColors.success,
          onTap: onLockScreenPlay,
        ),
        _buildQuickAction(
          icon: Icons.delete_sweep_outlined,
          label: AppStrings.clearCache,
          color: AppColors.warning,
          onTap: onClearCache,
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}