import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import 'bottom_nav_bar.dart';

/// Main app scaffold with bottom navigation
class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  // Map of route paths to tab indices
  final Map<String, int> _routeToIndex = {
    AppRoutes.dashboard: 0,
    AppRoutes.webview: 1,
    AppRoutes.profile: 2,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update current index based on current route
    final route = GoRouterState.of(context).uri.toString();
    for (final entry in _routeToIndex.entries) {
      if (route.startsWith(entry.key)) {
        if (_currentIndex != entry.value) {
          setState(() {
            _currentIndex = entry.value;
          });
        }
        break;
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to corresponding route
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.webview);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}