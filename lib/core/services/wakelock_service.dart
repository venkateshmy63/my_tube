import 'package:wakelock_plus/wakelock_plus.dart';

/// Wakelock service to keep the screen on during playback
class WakelockService {
  /// Enable wakelock (keep screen on)
  static Future<void> enable() async {
    try {
      await WakelockPlus.enable();
    } catch (_) {
      // Wakelock may not be supported on all platforms
    }
  }

  /// Disable wakelock (allow screen to turn off)
  static Future<void> disable() async {
    try {
      await WakelockPlus.disable();
    } catch (_) {
      // Wakelock may not be supported on all platforms
    }
  }

  /// Check if wakelock is currently enabled
  static Future<bool> isEnabled() async {
    try {
      return await WakelockPlus.enabled;
    } catch (_) {
      return false;
    }
  }

  /// Toggle wakelock state
  static Future<void> toggle() async {
    try {
      final enabled = await WakelockPlus.enabled;
      if (enabled) {
        await WakelockPlus.disable();
      } else {
        await WakelockPlus.enable();
      }
    } catch (_) {
      // Wakelock may not be supported on all platforms
    }
  }
}