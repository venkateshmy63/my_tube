import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// About Us screen
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.aboutUs),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.play_circle_filled,
                      size: 48,
                      color: AppColors.highlight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AppStrings.appTagline,
                    style: TextStyle(color: AppColors.subtle, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // What is this app?
            _buildSection(
              title: 'What is this app?',
              content:
                  'my_tube is a Flutter-based mobile application designed to provide a persistent WebView experience for video playback. It enables you to watch content — including YouTube videos — on your lock screen, in Picture-in-Picture (PiP) mode, and in the background without pausing.\n\n'
                  'The app is built with a focus on media continuity, ensuring your playback experience is never interrupted by screen locks, app switches, or other system events.\n\n'
                  'Whether you\'re listening to music, watching tutorials, or following along with a lecture, my_tube keeps your content playing no matter what.',
            ),
            const SizedBox(height: 24),
            // Key Features
            _buildSection(
              title: 'Key Features',
              content: null,
              bullets: [
                'Background audio/video playback without pausing',
                'Picture-in-Picture (PiP) mode on Android',
                'Lock screen playback support',
                'Full-featured in-app browser with navigation controls',
                'Quick-access dashboard with playback status',
                'Configurable settings and preferences',
              ],
            ),
            const SizedBox(height: 24),
            // Version badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Version 0.1.0 • Build 1',
                  style: TextStyle(color: AppColors.subtle, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // GitHub/Website link placeholder
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Visit Website'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String? content,
    List<String>? bullets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (content != null)
          Text(
            content,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        if (bullets != null)
          ...bullets.map((bullet) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '•  ',
                  style: TextStyle(color: AppColors.highlight, fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    bullet,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }
}