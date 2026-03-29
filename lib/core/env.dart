import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed, safe access to environment variables loaded from `.env`.
abstract final class Env {
  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL'];
    assert(
      value != null && value.isNotEmpty,
      'SUPABASE_URL is not set in .env',
    );
    return value!;
  }

  static String get supabaseAnonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    assert(
      value != null && value.isNotEmpty,
      'SUPABASE_ANON_KEY is not set in .env',
    );
    return value!;
  }

  /// Call once at app startup, before [runApp].
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
