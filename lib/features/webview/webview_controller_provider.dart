import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/constants/app_strings.dart';

/// Provider for WebViewController
final webViewControllerProvider = StateNotifierProvider<WebViewControllerNotifier, WebViewController?>(
  (ref) => WebViewControllerNotifier(),
);

/// Notifier to manage WebViewController state
class WebViewControllerNotifier extends StateNotifier<WebViewController?> {
  WebViewControllerNotifier() : super(null);

  /// Initialize the WebViewController with default settings
  WebViewController initController({String initialUrl = AppStrings.defaultHomeUrl}) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress
          },
          onPageStarted: (String url) {
            // Page started loading
          },
          onPageFinished: (String url) {
            // Page finished loading
          },
          onWebResourceError: (WebResourceError error) {
            // Handle error
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));

    state = controller;
    return controller;
  }

  /// Load a URL in the WebView
  void loadUrl(String url) {
    state?.loadRequest(Uri.parse(url));
  }

  /// Go back in navigation history
  void goBack() {
    state?.goBack();
  }

  /// Go forward in navigation history
  void goForward() {
    state?.goForward();
  }

  /// Reload the current page
  void reload() {
    state?.reload();
  }

  /// Clear cache and cookies
  Future<void> clearCache() async {
    await state?.clearCache();
    await state?.clearLocalStorage();
  }
}

/// Provider for current URL
final currentUrlProvider = StateProvider<String>((ref) => AppStrings.defaultHomeUrl);

/// Provider for loading progress
final loadingProgressProvider = StateProvider<int>((ref) => 0);

/// Provider for page title
final pageTitleProvider = StateProvider<String>((ref) => '');

/// Provider for can go back state
final canGoBackProvider = StateProvider<bool>((ref) => false);

/// Provider for can go forward state
final canGoForwardProvider = StateProvider<bool>((ref) => false);