import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_client_service.dart';

class SupabasePublicDataRepository {
  SupabasePublicDataRepository({SupabaseClient? client})
      : _client = client ?? SupabaseClientService.client;

  final SupabaseClient _client;

  Future<void> testConnection() async {
    await _client.from('beaches').select('id').limit(1);
  }

  Future<List<Map<String, dynamic>>> fetchActiveBeaches() async {
    final response = await _client
        .from('beaches')
        .select(
          'id,name,slug,city,state,country,neighborhood,status,is_active',
        )
        .eq('status', 'active')
        .eq('is_active', true)
        .order('name');

    return response.map(Map<String, dynamic>.from).toList();
  }

  Future<List<Map<String, dynamic>>> fetchApprovedActiveEstablishments() async {
    final response = await _client
        .from('establishments')
        .select(
          'id,beach_id,name,slug,description,operation_type,address,reference_point,average_rating,reviews_count,status,is_active',
        )
        .eq('status', 'approved')
        .eq('is_active', true)
        .order('name');

    return response.map(Map<String, dynamic>.from).toList();
  }
}
