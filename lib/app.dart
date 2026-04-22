import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_routes.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/app_scaffold.dart';
import 'features/webview/webview_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/pages/about_us_screen.dart';
import 'features/profile/pages/privacy_policy_screen.dart';
import 'features/profile/pages/terms_screen.dart';
import 'features/profile/pages/faq_screen.dart';
import 'features/profile/pages/contact_screen.dart';
import 'features/profile/pages/settings_screen.dart';

/// Main application widget with routing and theme
class MyTubeApp extends StatelessWidget {
  const MyTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'my_tube',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.dark, // Default to dark theme as per PRD
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  // GoRouter configuration
  static final _router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      // Shell route with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: AppRoutes.dashboardName,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.webview,
            name: AppRoutes.webviewName,
            builder: (context, state) => const WebViewScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: AppRoutes.profileName,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Profile sub-pages
      GoRoute(
        path: AppRoutes.about,
        name: AppRoutes.aboutName,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        name: AppRoutes.privacyName,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.terms,
        name: AppRoutes.termsName,
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        name: AppRoutes.faqName,
        builder: (context, state) => const FAQScreen(),
      ),
      GoRoute(
        path: AppRoutes.contact,
        name: AppRoutes.contactName,
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}