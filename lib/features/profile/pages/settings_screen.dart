import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/url_validator.dart';
import '../../webview/webview_controller_provider.dart';

/// Settings screen - app preferences and configuration
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _urlController = TextEditingController();
  bool _backgroundPlay = true;
  bool _autoPip = false;
  String _videoQuality = 'Auto';
  String _theme = 'System';
  bool _isUrlValid = true;

  @override
  void initState() {
    super.initState();
    _urlController.text = AppStrings.defaultHomeUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _saveDefaultUrl() {
    final url = _urlController.text.trim();
    final normalizedUrl = UrlValidator.normalize(url);
    if (UrlValidator.isValid(normalizedUrl)) {
      setState(() {
        _isUrlValid = true;
      });
      ref.read(currentUrlProvider.notifier).state = normalizedUrl;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default URL saved'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      setState(() {
        _isUrlValid = false;
      });
    }
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Clear History',
          style: TextStyle(color: AppColors.onSurface),
        ),
        content: const Text(
          'Are you sure you want to clear browsing history? This cannot be undone.',
          style: TextStyle(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('History cleared'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.highlight),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Clear Cache & Cookies',
          style: TextStyle(color: AppColors.onSurface),
        ),
        content: const Text(
          'Are you sure you want to clear cache and cookies? This will log you out of websites.',
          style: TextStyle(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(webViewControllerProvider.notifier).clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.cacheCleared),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.highlight),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Default Home URL
            _buildSectionHeader('Default Home URL'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _urlController,
                    style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Enter default URL',
                      hintStyle: TextStyle(color: AppColors.subtle.withValues(alpha: 0.7)),
                      errorText: _isUrlValid ? null : 'Please enter a valid URL',
                      errorStyle: const TextStyle(color: AppColors.highlight, fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveDefaultUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save URL'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Playback settings
            _buildSectionHeader('Playback'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      AppStrings.autoBackgroundPlay,
                      style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                    ),
                    value: _backgroundPlay,
                    onChanged: (value) {
                      setState(() {
                        _backgroundPlay = value;
                      });
                    },
                    activeThumbColor: AppColors.highlight,
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  SwitchListTile(
                    title: const Text(
                      AppStrings.autoPipOnHome,
                      style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                    ),
                    value: _autoPip,
                    onChanged: (value) {
                      setState(() {
                        _autoPip = value;
                      });
                    },
                    activeThumbColor: AppColors.highlight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Video Quality
            _buildSectionHeader('Video Quality'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: ['Auto', 'Low', 'High'].map((quality) {
                  return RadioListTile<String>(
                    title: Text(
                      quality,
                      style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
                    ),
                    value: quality,
                    groupValue: _videoQuality,
                    onChanged: (value) {
                      setState(() {
                        _videoQuality = value!;
                      });
                    },
                    activeColor: AppColors.highlight,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Theme
            _buildSectionHeader('Theme'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: ['Light', 'Dark', 'System'].map((theme) {
                  return RadioListTile<String>(
                    title: Text(
                      theme,
                      style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
                    ),
                    value: theme,
                    groupValue: _theme,
                    onChanged: (value) {
                      setState(() {
                        _theme = value!;
                      });
                    },
                    activeColor: AppColors.highlight,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Data management
            _buildSectionHeader('Data Management'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Clear Browsing History',
                      style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.subtle),
                    onTap: _clearHistory,
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  ListTile(
                    title: const Text(
                      'Clear Cache & Cookies',
                      style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.subtle),
                    onTap: _clearCache,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}