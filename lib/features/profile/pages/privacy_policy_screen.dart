import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Privacy Policy screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.privacyPolicy),
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
              'Privacy Policy',
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
              title: 'Data Collection',
              content:
                  'my_tube does not collect, store, or transmit any personal data. All browsing history, bookmarks, and settings are stored locally on your device using SharedPreferences. No data is sent to external servers.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Cookies',
              content:
                  'The app uses a WebView component that may store cookies from websites you visit. These cookies are managed by the WebView engine and are not accessible to the app. You can clear cookies at any time through the Settings screen.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Third-Party Services',
              content:
                  'This app uses YouTube\'s website within a WebView. YouTube\'s own privacy policy applies when you use YouTube through this app. The app does not intercept, read, or modify any data exchanged between you and YouTube or any other website.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Background Service',
              content:
                  'The app runs a foreground service on Android to enable background playback. This service requires a persistent notification, which is standard Android behavior. No personal data is collected or transmitted through this service.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'No Personal Data Collection',
              content:
                  'We want to be clear: my_tube does not collect, track, or share any personal information. There are no analytics, no crash reporting, and no advertising SDKs included in this application.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Contact',
              content:
                  'If you have questions about this privacy policy, please contact us through the Contact Us page in the app.',
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