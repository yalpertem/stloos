import 'env/env.dart';

class AppConfig {
  /// Returns the appropriate Supabase URL from environment
  static String get supabaseUrl => Env.supabaseUrl;
  
  /// Returns the Supabase anonymous key from environment
  static String get supabaseAnonKey => Env.supabaseAnonKey;
  
  /// Get the current platform info for debugging
  static String get platformInfo => Env.platformInfo;
  
  /// Returns the image base URL from environment
  static String get imageBaseUrl => Env.imageBaseUrl;
}