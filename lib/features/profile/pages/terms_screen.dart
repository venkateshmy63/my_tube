import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Terms of Service screen
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.termsOfService),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Last Updated: April 22, 2026',
              style: TextStyle(color: AppColors.subtle, fontSize: 12),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Acceptance',
              content:
                  'By downloading and using my_tube, you agree to these Terms of Service. If you do not agree with any part of these terms, you should not use the application.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: '2. Permitted Use',
              content:
                  'my_tube is provided for personal, non-commercial use. You may use the app to browse websites and play media content through the integrated WebView. The app is intended for development and testing purposes, and should be used in compliance with applicable laws and regulations.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: '3. Limitations',
              content:
                  '• The app does not guarantee compliance with YouTube\'s Terms of Service regarding background playback.\n'
                  '• Background playback and PiP features may not work on all devices or Android versions.\n'
                  '• The app is provided "as is" without warranties of any kind.\n'
                  '• We are not responsible for any content accessed through the WebView.\n'
                  '• The app may be affected by changes to third-party websites (e.g., YouTube) beyond our control.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: '4. Changes to Terms',
              content:
                  'We reserve the right to modify these Terms of Service at any time. Changes will be reflected in the "Last Updated" date. Continued use of the app after changes constitutes acceptance of the new terms.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: '5. Disclaimer',
              content:
                  'This application is provided for educational and development purposes. The developers are not liable for any misuse of the application or violation of third-party terms of service. Users are responsible for ensuring their use complies with all applicable terms and laws.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}