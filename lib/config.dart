import 'dart:io';

class AppConfig {
  static const String _localHost = '127.0.0.1';
  static const String _networkHost = '192.168.0.192'; // Your Mac's IP address
  static const int _port = 54321;
  
  static const String _anonKey = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';
  
  /// Returns the appropriate Supabase URL based on the platform
  static String get supabaseUrl {
    // Use localhost for web (Chrome), network IP for mobile devices
    final host = _isWebOrDesktop() ? _localHost : _networkHost;
    return 'http://$host:$_port';
  }
  
  /// Returns the Supabase anonymous key
  static String get supabaseAnonKey => _anonKey;
  
  /// Check if running on web or desktop platforms
  static bool _isWebOrDesktop() {
    try {
      // This will throw on web, so we catch and return true
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (e) {
      // Running on web
      return true;
    }
  }
  
  /// Get the current platform info for debugging
  static String get platformInfo {
    try {
      return Platform.operatingSystem;
    } catch (e) {
      return 'web';
    }
  }
}