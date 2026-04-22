import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Status card widget showing current playback status
class StatusCard extends StatelessWidget {
  final String status; // 'playing', 'pip', 'idle'
  final String statusText;

  const StatusCard({
    super.key,
    required this.status,
    required this.statusText,
  });

  Color get _statusColor {
    switch (status) {
      case 'playing':
        return AppColors.success;
      case 'pip':
        return AppColors.warning;
      default:
        return AppColors.subtle;
    }
  }

  IconData get _statusIcon {
    switch (status) {
      case 'playing':
        return Icons.play_circle_filled;
      case 'pip':
        return Icons.picture_in_picture_alt;
      default:
        return Icons.pause_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // Status indicator dot with pulse animation
              if (status == 'playing')
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.2),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.appTagline,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtle,
            ),
          ),
          const SizedBox(height: 16),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusIcon, size: 16, color: _statusColor),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}