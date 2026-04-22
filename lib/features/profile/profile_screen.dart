import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';

/// Profile screen - app settings, information pages, and user preferences
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              // Account section (placeholder)
              _buildSectionHeader('Account'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Avatar circle
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'U',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'No email set',
                            style: TextStyle(
                              color: AppColors.subtle,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.subtle),
                      onPressed: () {
                        // Edit profile placeholder
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // App Settings section
              _buildSectionHeader(AppStrings.settings),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.settings_outlined,
                      title: AppStrings.settings,
                      onTap: () => context.go(AppRoutes.settings),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      icon: Icons.play_circle_outline,
                      title: AppStrings.autoBackgroundPlay,
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: AppColors.highlight,
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      icon: Icons.picture_in_picture_alt_outlined,
                      title: AppStrings.autoPipOnHome,
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                        activeColor: AppColors.highlight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Information pages section
              _buildSectionHeader('Information'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: AppStrings.aboutUs,
                      onTap: () => context.go(AppRoutes.about),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: AppStrings.privacyPolicy,
                      onTap: () => context.go(AppRoutes.privacy),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      icon: Icons.description_outlined,
                      title: AppStrings.termsOfService,
                      onTap: () => context.go(AppRoutes.terms),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: AppStrings.faq,
                      onTap: () => context.go(AppRoutes.faq),
                    ),
                    _buildDivider(),
                    _buildSettingsTile(
                      icon: Icons.contact_mail_outlined,
                      title: AppStrings.contactUs,
                      onTap: () => context.go(AppRoutes.contact),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // App info footer
              Center(
                child: Column(
                  children: [
                    Text(
                      '${AppStrings.appName} v0.1.0',
                      style: const TextStyle(
                        color: AppColors.subtle,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.madeWithFlutter,
                      style: TextStyle(
                        color: AppColors.subtle,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurface, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.subtle),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: AppColors.divider, height: 1),
    );
  }
}