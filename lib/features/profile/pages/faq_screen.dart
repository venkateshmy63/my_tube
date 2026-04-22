import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// FAQ screen with expandable question/answer entries
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  static const _faqItems = [
    {
      'question': 'Why does the video stop when I lock my phone?',
      'answer':
          'By default, Android pauses media playback when the screen turns off. my_tube uses a foreground service with a wakelock to keep playback running. Make sure "Background Play" is enabled in Settings. On some devices, you may also need to exempt the app from battery optimization.',
    },
    {
      'question': 'How do I enable Picture-in-Picture?',
      'answer':
          'PiP mode is available on Android 8.0 (Oreo) and above. You can enable it by tapping the PiP button on the WebView screen, or it can auto-enter PiP when you press the home button (enable "Auto PiP on Home Press" in Settings). The PiP window will appear in the bottom-right corner of your screen.',
    },
    {
      'question': 'Does the app collect my browsing data?',
      'answer':
          'No. my_tube does not collect, track, or share any personal information. All browsing data is stored locally on your device. There are no analytics, crash reporting, or advertising SDKs in the app.',
    },
    {
      'question': 'Which video sites are supported?',
      'answer':
          'The app uses a standard WebView, so any website that plays video in a browser should work. YouTube is the primary tested site, but other video platforms like Vimeo, Dailymotion, and web-based players should also function.',
    },
    {
      'question': 'How do I set a default URL?',
      'answer':
          'Go to Profile → Settings → Default Home URL. Enter your preferred URL and tap Save. The WebView will load this URL whenever you open it or tap the Home button in navigation controls.',
    },
    {
      'question': 'Why do I see a notification when video plays in background?',
      'answer':
          'Android requires a persistent notification for foreground services. This notification is mandatory and cannot be removed while the background playback service is running. It ensures the system doesn\'t kill the service while media is playing.',
    },
    {
      'question': 'Is YouTube officially supported?',
      'answer':
          'YouTube\'s Terms of Service prohibit background playback in third-party apps without YouTube Premium. While my_tube can play YouTube content in a WebView, this may not comply with YouTube\'s ToS. The app is intended for development and testing purposes.',
    },
    {
      'question': 'How do I stop background playback?',
      'answer':
          'You can stop background playback by toggling the "Background Play" switch in Settings, or by using the "Stop Service" action in the persistent notification. You can also close the app entirely to stop the service.',
    },
    {
      'question': 'Does this work on iOS?',
      'answer':
          'iOS support is limited. Background audio requires AVAudioSession configuration, and PiP requires AVKit integration with WKWebView. Basic WebView functionality works on iOS, but background playback and PiP have limitations, especially with YouTube\'s player.',
    },
    {
      'question': 'How do I report a bug?',
      'answer':
          'You can report bugs through the Contact Us page in the app, or by visiting the project\'s GitHub repository and opening an issue. Please include your device model, Android version, and steps to reproduce the problem.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.faq),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _faqItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                title: Text(
                  item['question']!,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                iconColor: AppColors.highlight,
                collapsedIconColor: AppColors.subtle,
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    item['answer']!,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 13,
                      height: 1.6,
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
}