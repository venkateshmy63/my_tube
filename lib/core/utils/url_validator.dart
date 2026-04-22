/// URL validation utility
class UrlValidator {
  /// Validates if the given string is a valid URL
  static bool isValid(String url) {
    if (url.trim().isEmpty) return false;
    
    // Add https:// if no scheme is provided
    final String normalizedUrl = _normalizeUrl(url);
    
    try {
      final uri = Uri.parse(normalizedUrl);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  /// Normalizes a URL by adding https:// if no scheme is present
  static String normalize(String url) {
    return _normalizeUrl(url);
  }

  /// Internal method to normalize URL
  static String _normalizeUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;
    
    // Already has a scheme
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    
    // Add https:// prefix
    return 'https://$trimmed';
  }

  /// Extracts the domain from a URL
  static String getDomain(String url) {
    try {
      final uri = Uri.parse(_normalizeUrl(url));
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  /// Checks if the URL is a YouTube URL
  static bool isYouTubeUrl(String url) {
    final domain = getDomain(url).toLowerCase();
    return domain.contains('youtube.com') || domain.contains('youtu.be');
  }
}