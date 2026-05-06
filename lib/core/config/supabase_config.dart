class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool get isConfigured {
    return url.trim().isNotEmpty && publishableKey.trim().isNotEmpty;
  }

  static String? get validationMessage {
    if (url.trim().isEmpty && publishableKey.trim().isEmpty) {
      return 'Configure SUPABASE_URL e SUPABASE_PUBLISHABLE_KEY para testar a leitura publica.';
    }

    if (url.trim().isEmpty) {
      return 'Configure SUPABASE_URL para testar a leitura publica.';
    }

    if (publishableKey.trim().isEmpty) {
      return 'Configure SUPABASE_PUBLISHABLE_KEY para testar a leitura publica.';
    }

    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'SUPABASE_URL parece invalida. Use a Project URL do Supabase.';
    }

    return null;
  }
}
