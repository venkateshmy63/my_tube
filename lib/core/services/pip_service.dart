import 'package:flutter/services.dart';

/// Picture-in-Picture service using MethodChannel
class PipService {
  static const _channel = MethodChannel('app/pip');

  /// Check if PiP is available on this device
  static Future<bool> isAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isPiPAvailable');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Enter Picture-in-Picture mode
  static Future<bool> enterPiP() async {
    try {
      final result = await _channel.invokeMethod<bool>('enterPiP');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Exit Picture-in-Picture mode
  static Future<void> exitPiP() async {
    try {
      await _channel.invokeMethod('exitPiP');
    } on PlatformException {
      // Ignore errors when exiting PiP
    }
  }

  /// Listen to PiP mode changes
  static void onPiPModeChanged(Function(bool) onChanged) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPiPModeChanged') {
        onChanged(call.arguments as bool);
      }
    });
  }
}