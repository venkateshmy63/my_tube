import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import 'webview_controller_provider.dart';
import 'widgets/address_bar.dart';
import 'widgets/navigation_controls.dart';
import 'widgets/pip_toggle_button.dart';

/// WebView screen - full-featured in-app browser
class WebViewScreen extends ConsumerStatefulWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  bool _isFullscreen = false;
  bool _isPiPActive = false;
  bool _canGoBack = false;
  bool _canGoForward = false;
  int _loadingProgress = 0;
  String _currentUrl = AppStrings.defaultHomeUrl;

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(webViewControllerProvider.notifier).initController();
      _setupNavigationDelegate(controller);
    });
  }

  void _setupNavigationDelegate(WebViewController controller) {
    controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        setState(() {
          _loadingProgress = progress;
        });
      },
      onPageStarted: (String url) {
        setState(() {
          _currentUrl = url;
          _loadingProgress = 0;
        });
        ref.read(currentUrlProvider.notifier).state = url;
      },
      onPageFinished: (String url) {
        setState(() {
          _loadingProgress = 100;
        });
        _updateNavigationState();
      },
      onWebResourceError: (WebResourceError error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading page: ${error.description}'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    ));
  }

  Future<void> _updateNavigationState() async {
    final controller = ref.read(webViewControllerProvider);
    if (controller != null) {
      final canBack = await controller.canGoBack();
      final canForward = await controller.canGoForward();
      setState(() {
        _canGoBack = canBack;
        _canGoForward = canForward;
      });
    }
  }

  void _loadUrl(String url) {
    final controller = ref.read(webViewControllerProvider);
    if (controller != null) {
      controller.loadRequest(Uri.parse(url));
      setState(() {
        _currentUrl = url;
      });
    }
  }

  void _goBack() {
    ref.read(webViewControllerProvider)?.goBack();
  }

  void _goForward() {
    ref.read(webViewControllerProvider)?.goForward();
  }

  void _goHome() {
    _loadUrl(AppStrings.defaultHomeUrl);
  }

  void _refresh() {
    ref.read(webViewControllerProvider)?.reload();
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  void _togglePiP() {
    setState(() {
      _isPiPActive = !_isPiPActive;
    });
    // PiP will be implemented via MethodChannel in pip_service.dart
    // For now, just toggle the state
    if (_isPiPActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PiP mode activated'),
          backgroundColor: AppColors.accent,
        ),
      );
    }
  }

  Future<void> _shareUrl() async {
    final uri = Uri.parse(_currentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(webViewControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // On back press, always go to dashboard (home)
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.dashboard);
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Address bar (hidden in fullscreen)
            if (!_isFullscreen)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: AddressBar(
                  currentUrl: _currentUrl,
                  onUrlSubmitted: _loadUrl,
                  onReload: _refresh,
                  onShare: _shareUrl,
                  isLoading: _loadingProgress < 100 && _loadingProgress > 0,
                ),
              ),
            // Loading indicator
            if (_loadingProgress < 100 && _loadingProgress > 0)
              LinearProgressIndicator(
                value: _loadingProgress / 100,
                backgroundColor: AppColors.surface,
                color: AppColors.highlight,
                minHeight: 2,
              ),
            // WebView area
            Expanded(
              child: Stack(
                children: [
                  // WebView content
                  if (controller != null)
                    WebViewWidget(controller: controller)
                  else
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.highlight,
                      ),
                    ),
                  // PiP toggle button (floating)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: PiPToggleButton(
                      isPiPActive: _isPiPActive,
                      onToggle: _togglePiP,
                    ),
                  ),
                ],
              ),
            ),
            // Navigation controls (hidden in fullscreen)
            if (!_isFullscreen)
              NavigationControls(
                canGoBack: _canGoBack,
                canGoForward: _canGoForward,
                onBack: _goBack,
                onForward: _goForward,
                onHome: _goHome,
                onRefresh: _refresh,
                onToggleFullscreen: _toggleFullscreen,
                isFullscreen: _isFullscreen,
              ),
          ],
        ),
      ),
      ),
    );
  }
}