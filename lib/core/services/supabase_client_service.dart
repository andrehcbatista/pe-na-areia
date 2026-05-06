import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

class SupabaseConfigurationException implements Exception {
  const SupabaseConfigurationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SupabaseClientService {
  SupabaseClientService._();

  static SupabaseClient? _client;

  static bool get isConfigured => SupabaseConfig.validationMessage == null;

  static String? get configurationMessage => SupabaseConfig.validationMessage;

  static SupabaseClient get client {
    final message = SupabaseConfig.validationMessage;
    if (message != null) {
      throw SupabaseConfigurationException(message);
    }

    return _client ??= SupabaseClient(
      SupabaseConfig.url.trim(),
      SupabaseConfig.publishableKey.trim(),
    );
  }
}
