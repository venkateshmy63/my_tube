import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import 'widgets/status_card.dart';
import 'widgets/quick_links_grid.dart';
import 'widgets/recent_sites_list.dart';
import '../webview/webview_controller_provider.dart';

/// Dashboard screen - quick-access hub
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _playbackStatus = 'idle';
  int _pagesVisited = 0;
  int _backgroundMinutes = 0;
  int _pipSessions = 0;
  final List<String> _recentSites = [
    'https://youtube.com',
    'https://google.com',
    'https://github.com',
  ];

  void _openYouTube() {
    ref.read(currentUrlProvider.notifier).state = AppStrings.youtubeUrl;
    context.go(AppRoutes.webview);
  }

  void _togglePiP() {
    setState(() {
      _playbackStatus = _playbackStatus == 'pip' ? 'idle' : 'pip';
      if (_playbackStatus == 'pip') _pipSessions++;
    });
  }

  void _lockScreenPlay() {
    setState(() {
      _playbackStatus = _playbackStatus == 'playing' ? 'idle' : 'playing';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _playbackStatus == 'playing'
              ? 'Background play enabled'
              : 'Background play disabled',
        ),
        backgroundColor:
            _playbackStatus == 'playing' ? AppColors.success : AppColors.subtle,
      ),
    );
  }

  void _clearCache() {
    ref.read(webViewControllerProvider.notifier).clearCache();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.cacheCleared),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _openSite(String url) {
    ref.read(currentUrlProvider.notifier).state = url;
    context.go(AppRoutes.webview);
  }

  void _removeSite(int index) {
    setState(() {
      _recentSites.removeAt(index);
    });
  }

  String get _statusText {
    switch (_playbackStatus) {
      case 'playing':
        return AppStrings.playingInBackground;
      case 'pip':
        return AppStrings.pipActive;
      default:
        return AppStrings.idle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card with status
              StatusCard(
                status: _playbackStatus,
                statusText: _statusText,
              ),
              const SizedBox(height: 24),
              // Quick actions section
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              QuickLinksGrid(
                onOpenYouTube: _openYouTube,
                onTogglePiP: _togglePiP,
                onLockScreenPlay: _lockScreenPlay,
                onClearCache: _clearCache,
              ),
              const SizedBox(height: 24),
              // Recent sites section
              Text(
                'Recent Sites',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              RecentSitesList(
                recentSites: _recentSites,
                onSiteTap: _openSite,
                onSiteLongPress: _removeSite,
              ),
              const SizedBox(height: 24),
              // Stats row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.article_outlined,
                      label: AppStrings.pagesVisited,
                      value: '$_pagesVisited',
                    ),
                    _buildStatItem(
                      icon: Icons.timer_outlined,
                      label: AppStrings.timeInBackground,
                      value: '${_backgroundMinutes}m',
                    ),
                    _buildStatItem(
                      icon: Icons.picture_in_picture_alt_outlined,
                      label: AppStrings.pipSessions,
                      value: '$_pipSessions',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.highlight, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.subtle,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}