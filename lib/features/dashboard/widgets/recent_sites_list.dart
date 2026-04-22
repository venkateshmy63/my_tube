import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Recent sites list widget for the Dashboard screen
class RecentSitesList extends StatelessWidget {
  final List<String> recentSites;
  final Function(String) onSiteTap;
  final Function(int) onSiteLongPress;

  const RecentSitesList({
    super.key,
    required this.recentSites,
    required this.onSiteTap,
    required this.onSiteLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (recentSites.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No recent sites',
            style: TextStyle(color: AppColors.subtle, fontSize: 14),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: recentSites.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final site = recentSites[index];
          return GestureDetector(
            onTap: () => onSiteTap(site),
            onLongPress: () => onSiteLongPress(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.language,
                    size: 14,
                    color: AppColors.subtle,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _truncateUrl(site),
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _truncateUrl(String url) {
    if (url.length > 20) {
      return '${url.substring(0, 20)}...';
    }
    return url;
  }
}