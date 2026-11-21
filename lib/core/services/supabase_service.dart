import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://placeholder.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'placeholder-anon-key',
  );

  static bool _isInitialized = false;

  static bool get isConfigured =>
      supabaseUrl != 'https://placeholder.supabase.co' &&
      supabaseAnonKey != 'placeholder-anon-key';

  static Future<void> initialize() async {
    if (_isInitialized) return;

    if (isConfigured) {
      try {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        );
        _isInitialized = true;
      } catch (e) {
        // Fallback gracefully in offline / dev environments
        _isInitialized = false;
      }
    }
  }

  static SupabaseClient? get client {
    if (_isInitialized && isConfigured) {
      return Supabase.instance.client;
    }
    return null;
  }
}
