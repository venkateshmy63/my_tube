# my_tube

# Product Requirements Document
## Flutter App — WebView Player with Background & PiP Support

**Version:** 1.0.0  
**Last Updated:** April 22, 2026  
**Platform:** Android (primary), iOS (secondary)

---

## 1. Overview

A Flutter mobile application built around a persistent WebView experience — capable of running content (including YouTube videos) on the lock screen, in Picture-in-Picture (PiP) mode, and in the background without pausing. The app is structured around three core bottom-navigation layouts: **Dashboard**, **WebView Browser**, and **Profile**.

---

## 2. Goals & Success Criteria

| Goal | Success Metric |
|------|----------------|
| YouTube plays on lock screen | Video continues after screen lock |
| PiP mode works while app is backgrounded | PiP window appears on home screen |
| Background audio/video does not pause | Verified via Android background service |
| App launches in under 2 seconds | Cold start ≤ 2s on mid-range device |
| Clean, modern UI | No third-party UI library dependency for core design |

---

## 3. Target Platforms

- **Android:** API 26+ (Oreo and above) — required for PiP support
- **iOS:** iOS 14+ — limited PiP (WebKit AVKit), best-effort support

---

## 4. Architecture Overview

```
lib/
├── main.dart
├── app.dart                        # MaterialApp, theme, routes
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   ├── services/
│   │   ├── background_service.dart  # flutter_background_service
│   │   ├── pip_service.dart         # floating_window / PiP handler
│   │   └── wakelock_service.dart    # wakelock_plus
│   └── utils/
│       └── url_validator.dart
├── features/
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   └── widgets/
│   │       ├── quick_links_grid.dart
│   │       ├── status_card.dart
│   │       └── recent_sites_list.dart
│   ├── webview/
│   │   ├── webview_screen.dart
│   │   ├── webview_controller_provider.dart
│   │   └── widgets/
│   │       ├── address_bar.dart
│   │       ├── navigation_controls.dart
│   │       └── pip_toggle_button.dart
│   └── profile/
│       ├── profile_screen.dart
│       └── pages/
│           ├── about_us_screen.dart
│           ├── privacy_policy_screen.dart
│           ├── faq_screen.dart
│           ├── terms_screen.dart
│           ├── contact_screen.dart
│           └── settings_screen.dart
└── shared/
    ├── widgets/
    │   ├── bottom_nav_bar.dart
    │   └── app_scaffold.dart
    └── theme/
        └── app_theme.dart
```

---

## 5. Dependency Stack

```yaml
dependencies:
  flutter:
    sdk: flutter

  # WebView
  webview_flutter: ^4.7.0
  webview_flutter_android: ^3.16.0
  webview_flutter_wkwebview: ^3.13.0

  # Background Execution
  flutter_background_service: ^5.0.5
  flutter_background_service_android: ^6.2.2

  # Lock Screen / Wake Lock
  wakelock_plus: ^1.2.5

  # Picture-in-Picture (Android native bridge)
  pip_flutter: ^0.0.4           # or implement via MethodChannel

  # State Management
  flutter_riverpod: ^2.5.1

  # Navigation
  go_router: ^13.2.0

  # Storage (bookmarks, settings)
  shared_preferences: ^2.2.3

  # UI Extras
  flutter_svg: ^2.0.10
  cached_network_image: ^3.3.1
  url_launcher: ^6.2.7
```

---

## 6. Screen & Feature Specifications

---

### 6.1 Root Shell — Bottom Navigation

**Widget:** `AppScaffold` wrapping `BottomNavigationBar` or `NavigationBar`

**Tabs:**
| Index | Label | Icon | Route |
|-------|-------|------|-------|
| 0 | Home | `home_outlined` | `/dashboard` |
| 1 | Browser | `language_outlined` | `/webview` |
| 2 | Profile | `person_outline` | `/profile` |

**Design Notes:**
- Floating pill-style bottom nav bar with subtle elevation and rounded corners
- Active tab uses filled icon + accent color indicator dot
- Navigation state preserved across tab switches (no re-render)
- Bottom nav hidden in PiP mode and full-screen WebView

---

### 6.2 Dashboard Screen

**Route:** `/dashboard`

**Purpose:** Quick-access hub showing app status, bookmarked/recent sites, and feature shortcuts.

**Sections:**

#### 6.2.1 Header Card
- App name + tagline
- Current playback status badge ("Playing in Background" / "PiP Active" / "Idle")
- Colored status indicator dot (green / amber / grey)

#### 6.2.2 Quick Actions Grid (2×2)
| Action | Icon | Behavior |
|--------|------|----------|
| Open YouTube | YouTube icon | Loads `https://youtube.com` in WebView tab |
| Toggle PiP | `picture_in_picture` | Activates PiP mode for current WebView |
| Lock Screen Play | `lock_open` | Enables wakelock + background service |
| Clear Cache | `delete_sweep` | Clears WebView cache + cookies |

#### 6.2.3 Recent Sites List
- Scrollable horizontal chip list of last 5 visited URLs
- Tap to reload in WebView
- Long-press to delete from history

#### 6.2.4 Stats Row
- Pages visited (session)
- Time in background (minutes)
- PiP sessions count

**State Management:** Riverpod `StateNotifier` for playback status + session stats.

---

### 6.3 WebView Screen

**Route:** `/webview`

**Purpose:** Full-featured in-app browser with background playback, PiP, and lock-screen-safe video.

#### 6.3.1 Address Bar
- Rounded text field at top
- Shows current URL (truncated to domain when idle)
- Expands on tap for full URL editing
- Trailing: Reload button, Share button
- Leading: Security lock icon (https vs http)

#### 6.3.2 WebView Area
- `WebViewController` with JavaScript enabled
- Media autoplay allowed: `setMediaPlaybackRequiresUserGesture(false)`
- Android: Use `WebSettings.setMediaPlaybackRequiresUserGesture(false)` via platform channel if needed
- `InAppWebView`-style configuration for background audio

#### 6.3.3 Navigation Controls Bar (bottom)
- Back, Forward, Home (loads default URL), Refresh
- PiP toggle button (floating action chip on right side)
- Full-screen toggle

#### 6.3.4 Loading Indicator
- Slim linear progress bar below address bar
- Dismisses on `onPageFinished`

#### 6.3.5 Default URL
- Preloaded with `https://www.youtube.com`
- Configurable via Settings screen

---

### 6.4 Background Playback Service

**File:** `lib/core/services/background_service.dart`

**Strategy:**
1. Use `flutter_background_service` to start a foreground Android service
2. Service keeps a persistent notification: "App is running in background"
3. On `AppLifecycleState.paused`, service activates
4. WebView retains its rendered state via `AndroidWebView` background tab behavior
5. On Android 12+, foreground service type = `mediaPlayback`

**AndroidManifest.xml additions:**
```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

<service
  android:name="id.flutter.flutter_background_service.BackgroundService"
  android:foregroundServiceType="mediaPlayback"
  android:exported="false" />
```

**Notification Channel:**
- ID: `playback_channel`
- Name: "Playback Service"
- Importance: `IMPORTANCE_LOW` (silent, non-intrusive)
- Actions: "Open App", "Stop Service"

---

### 6.5 Picture-in-Picture (PiP) Mode

**Android Implementation:**

```kotlin
// MainActivity.kt
override fun onUserLeaveHint() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val params = PictureInPictureParams.Builder()
            .setAspectRatio(Rational(16, 9))
            .build()
        enterPictureInPictureMode(params)
    }
}
```

**Flutter side (MethodChannel):**
```dart
// pip_service.dart
static const _channel = MethodChannel('app/pip');

Future<void> enterPiP() async {
  await _channel.invokeMethod('enterPiP');
}
```

**Behavior:**
- PiP activates on: home button press while video is playing, manual PiP button tap
- PiP window size: 16:9 ratio, positioned bottom-right
- Returns to full app on PiP window tap
- Handles `onPictureInPictureModeChanged` to update Riverpod state

---

### 6.6 Lock Screen Playback

**Strategy:**
1. `wakelock_plus`: `WakelockPlus.enable()` when playback starts
2. Android `FLAG_KEEP_SCREEN_ON` via `wakelock_plus`
3. Background service with `mediaPlayback` type persists through screen-off
4. WebView does NOT pause when screen locks — verified by Android background service holding CPU wakelock

**iOS Note:** Lock screen playback requires `AVAudioSession` category set to `.playback` — handled via native AppDelegate configuration.

---

### 6.7 Profile Screen

**Route:** `/profile`

**Purpose:** App settings, information pages, and user preferences.

**Layout:** `ListView` with grouped section tiles.

#### Sections:

**Account (placeholder — no auth required in v1.0)**
- Avatar circle (initials or placeholder)
- Display name field (editable, stored locally)
- Email (optional, stored locally)

**App Settings (→ `/settings`)**
- Default URL (text input, saved to SharedPreferences)
- Auto-enable background play (toggle)
- Auto-enter PiP on home press (toggle)
- Clear browsing history
- Clear cache & cookies

**Information Pages:**
| Page | Route | Content |
|------|-------|---------|
| About Us | `/profile/about` | App description, version, team |
| Privacy Policy | `/profile/privacy` | Data handling, no tracking statement |
| Terms of Service | `/profile/terms` | Usage terms |
| FAQ | `/profile/faq` | 8–10 common questions with expandable answers |
| Contact Us | `/profile/contact` | Email link + feedback form |

**App Info Footer:**
- App version (from `package_info_plus`)
- Build number
- "Made with Flutter" badge

---

### 6.8 Sub-Pages Detail

#### About Us (`/profile/about`)
- Hero section: App logo + tagline
- Section: "What is this app?" — 2–3 paragraphs
- Section: "Key Features" — bulleted list (background play, PiP, lock screen)
- App version badge
- GitHub/Website link (placeholder)

#### Privacy Policy (`/profile/privacy`)
- Scrollable rich text
- Sections: Data Collection, Cookies, Third-Party Services (YouTube embed), Contact
- "Last Updated" date stamp
- No personal data collection statement (if applicable)

#### FAQ (`/profile/faq`)
- `ExpansionTile` list
- 10 pre-written Q&A entries including:
  - "Why does the video stop when I lock my phone?"
  - "How do I enable Picture-in-Picture?"
  - "Does the app collect my browsing data?"
  - "Which video sites are supported?"
  - "How do I set a default URL?"
  - "Why do I see a notification when video plays in background?"
  - "Is YouTube officially supported?"
  - "How do I stop background playback?"
  - "Does this work on iOS?"
  - "How do I report a bug?"

#### Terms of Service (`/profile/terms`)
- Scrollable plain text
- Sections: Acceptance, Permitted Use, Limitations, Changes to Terms

#### Contact Us (`/profile/contact`)
- Email tile (opens mail app)
- "Report a Bug" tile (opens GitHub Issues URL or mailto)
- Feedback text area + submit button (sends via mailto)
- Social links row (placeholder icons)

#### Settings (`/profile/settings`)
- Default Home URL (TextFormField with validation)
- Background Play toggle (Riverpod-backed)
- Auto PiP toggle
- Video Quality preference (Auto / Low / High) — passed as URL param hint
- Theme: Light / Dark / System
- Clear History button (with confirmation dialog)
- Clear Cache button (with confirmation dialog)

---

## 7. UI Design System

### 7.1 Color Palette
```dart
// app_colors.dart
static const primary     = Color(0xFF1A1A2E);   // Deep navy
static const accent      = Color(0xFF0F3460);   // Electric indigo
static const highlight   = Color(0xFFE94560);   // Vivid red-pink
static const surface     = Color(0xFF16213E);   // Dark card surface
static const background  = Color(0xFF0A0A1A);   // Near-black bg
static const onPrimary   = Color(0xFFFFFFFF);
static const onSurface   = Color(0xFFE0E0E0);
static const subtle      = Color(0xFF6C7A93);   // Muted label text
```

### 7.2 Typography
```dart
// Use Google Fonts: 'Syne' (headings) + 'DM Sans' (body)
headlineLarge : Syne, 28px, w700
titleMedium   : Syne, 16px, w600
bodyMedium    : DM Sans, 14px, w400
labelSmall    : DM Sans, 11px, w500, letter-spacing 0.8
```

### 7.3 Component Tokens
- Border radius: `12px` (cards), `24px` (chips/pills), `8px` (inputs)
- Elevation: Cards use `BoxShadow` with 20% opacity, no Material elevation
- Spacing scale: `4, 8, 12, 16, 24, 32, 48` dp
- Icon size: `20px` (nav), `24px` (action), `32px` (hero)

### 7.4 Animations
- Page transitions: Slide + fade (300ms, `Curves.easeInOutCubic`)
- Status badge: Pulse animation (repeat, 1.5s) when "Playing"
- Quick action tiles: Scale on tap (0.95 scale, 100ms)
- Bottom nav indicator: Animated width expansion

---

## 8. Permissions Required

### Android (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />  <!-- Android 13+ -->
<uses-permission android:name="android.permission.PICTURE_IN_PICTURE" />
```

### iOS (`Info.plist`)
```xml
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
  <string>fetch</string>
</array>
```

---

## 9. Testing Plan

### 9.1 Unit Tests
- URL validator (valid/invalid URLs)
- Settings persistence (SharedPreferences read/write)
- Background service start/stop lifecycle

### 9.2 Integration Tests
| Test Case | Expected Result |
|-----------|----------------|
| Load YouTube URL | Page renders, video plays |
| Lock screen while playing | Audio/video continues |
| Press home while video plays | PiP window appears (Android) |
| Toggle background play off | Service stops, video pauses on bg |
| Navigate between tabs | WebView state retained |
| FAQ expansion | All tiles expand/collapse correctly |
| Settings save default URL | URL persists on app restart |

### 9.3 Stability Tests
- Play YouTube for 30 minutes in background — no crash
- Enter/exit PiP 20 times — no memory leak
- Lock/unlock screen 10 times during playback — no pause
- Kill and relaunch app — settings persist

---

## 10. Known Limitations & Notes

1. **YouTube Terms of Service:** YouTube's ToS prohibits background playback in third-party apps without YouTube Premium. This app does not guarantee compliance — use for development/testing purposes.
2. **iOS PiP:** Full PiP support requires native AVKit integration. WebKit WKWebView PiP is available on iOS 16+ for inline HTML5 video but has limitations with YouTube's player.
3. **Android 12+ Battery Optimization:** Background service may be killed by aggressive battery savers. Guide users to exempt the app from battery optimization.
4. **DRM Content:** Some YouTube content with DRM may not play in WebView without Widevine support. Enable `webview_flutter_android`'s `setMediaDrmServerCertificate` if needed.
5. **Notification Permission (Android 13+):** Must request `POST_NOTIFICATIONS` at runtime before starting background service.

---

## 11. Milestones

| Phase | Deliverable | Target |
|-------|-------------|--------|
| Phase 1 | Project scaffold + theme + navigation shell | Week 1 |
| Phase 2 | WebView screen + address bar + basic loading | Week 1–2 |
| Phase 3 | Background service + wakelock integration | Week 2 |
| Phase 4 | PiP mode (Android native bridge) | Week 2–3 |
| Phase 5 | Dashboard screen + quick actions | Week 3 |
| Phase 6 | Profile screen + all sub-pages | Week 3–4 |
| Phase 7 | Settings persistence + polish | Week 4 |
| Phase 8 | Testing + bug fixes | Week 4–5 |

---

## 12. Out of Scope (v1.0)

- User authentication or accounts
- Cloud sync of bookmarks/history
- Custom ad blocking
- Download manager
- Multiple simultaneous WebView tabs
- Cast / Chromecast support

---

*End of PRD*
