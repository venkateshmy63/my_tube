import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'app.dart';
import 'core/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WebView platform for Android
  WebViewPlatform.instance = WebViewPlatform.instance;

  // Initialize background service
  await BackgroundService.initialize();

  runApp(const MyTubeApp());
}
