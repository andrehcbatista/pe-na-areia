import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_client_service.dart';
import '../../models/establishment.dart';
import '../../models/menu_category.dart';
import '../../models/menu_item.dart';
import '../mock/mock_establishments.dart';

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

  Future<Map<String, dynamic>?> fetchBoaViagemBeach() async {
    final response = await _client
        .from('beaches')
        .select(
          'id,name,slug,city,state,country,neighborhood,status,is_active',
        )
        .eq('slug', 'boa-viagem')
        .eq('status', 'active')
        .eq('is_active', true)
        .limit(1);

    final records = response.map(Map<String, dynamic>.from).toList();
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<List<Map<String, dynamic>>> fetchApprovedActiveEstablishmentsForBeach(
    String beachId,
  ) async {
    final response = await _client
        .from('establishments')
        .select(
          'id,beach_id,name,slug,description,operation_type,address,reference_point,average_rating,reviews_count,status,is_active',
        )
        .eq('beach_id', beachId)
        .eq('status', 'approved')
        .eq('is_active', true)
        .order('name');

    return response.map(Map<String, dynamic>.from).toList();
  }

  Future<Map<String, dynamic>?> fetchApprovedActiveEstablishmentById(
    String establishmentId,
  ) async {
    final response = await _client
        .from('establishments')
        .select(
          'id,beach_id,name,slug,description,operation_type,phone,address,reference_point,latitude,longitude,cover_image_url,logo_url,opening_hours,average_rating,reviews_count,status,is_active',
        )
        .eq('id', establishmentId)
        .eq('status', 'approved')
        .eq('is_active', true)
        .limit(1);

    final records = response.map(Map<String, dynamic>.from).toList();
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<List<Map<String, dynamic>>> fetchActiveAvailabilitySnapshots(
    List<String> establishmentIds,
  ) async {
    if (establishmentIds.isEmpty) {
      return const [];
    }

    final response = await _client
        .from('establishment_availability_snapshots')
        .select(
          'id,establishment_id,total_sets,available_sets,is_active,captured_at',
        )
        .inFilter('establishment_id', establishmentIds)
        .eq('is_active', true)
        .order('captured_at', ascending: false);

    return response.map(Map<String, dynamic>.from).toList();
  }

  Future<List<Establishment>>
      fetchBoaViagemApprovedActiveEstablishments() async {
    final beach = await fetchBoaViagemBeach();
    final beachId = _stringValue(beach?['id']);
    if (beachId == null) {
      return const [];
    }

    final establishments =
        await fetchApprovedActiveEstablishmentsForBeach(beachId);
    if (establishments.isEmpty) {
      return const [];
    }

    final ids = establishments
        .map((establishment) => _stringValue(establishment['id']))
        .whereType<String>()
        .toList();
    final snapshots = await fetchActiveAvailabilitySnapshots(ids);
    final snapshotsByEstablishment = <String, Map<String, dynamic>>{};

    for (final snapshot in snapshots) {
      final establishmentId = _stringValue(snapshot['establishment_id']);
      if (establishmentId != null &&
          !snapshotsByEstablishment.containsKey(establishmentId)) {
        snapshotsByEstablishment[establishmentId] = snapshot;
      }
    }

    return [
      for (var index = 0; index < establishments.length; index++)
        _establishmentFromRecord(
          establishments[index],
          snapshotsByEstablishment,
          index,
        ),
    ];
  }

  Future<Establishment?> fetchApprovedActiveEstablishmentDetails(
    String establishmentId,
  ) async {
    final establishment =
        await fetchApprovedActiveEstablishmentById(establishmentId);
    if (establishment == null) {
      return null;
    }

    final snapshots = await fetchActiveAvailabilitySnapshots([establishmentId]);
    final snapshotsByEstablishment = <String, Map<String, dynamic>>{};
    if (snapshots.isNotEmpty) {
      snapshotsByEstablishment[establishmentId] = snapshots.first;
    }

    return _establishmentFromRecord(
      establishment,
      snapshotsByEstablishment,
      0,
    );
  }

  Future<List<Map<String, dynamic>>> fetchActiveMenuCategories(
    String establishmentId,
  ) async {
    final response = await _client
        .from('menu_categories')
        .select('id,establishment_id,name,description,display_order,is_active')
        .eq('establishment_id', establishmentId)
        .eq('is_active', true)
        .order('display_order')
        .order('name');

    return response.map(Map<String, dynamic>.from).toList();
  }

  Future<List<Map<String, dynamic>>> fetchActiveMenuItems({
    required String establishmentId,
    String? categoryId,
  }) async {
    var query = _client
        .from('menu_items')
        .select(
          'id,establishment_id,category_id,name,description,price_cents,status,is_active,display_order,cashback_preview_text',
        )
        .eq('establishment_id', establishmentId)
        .eq('is_active', true);

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final response = await query.order('display_order').order('name');

    return response.map(Map<String, dynamic>.from).toList();
  }

  Future<List<MenuCategory>> fetchMenuForEstablishment(
    String establishmentId,
  ) async {
    final categories = await fetchActiveMenuCategories(establishmentId);
    final items = await fetchActiveMenuItems(establishmentId: establishmentId);

    if (categories.isEmpty || items.isEmpty) {
      return const [];
    }

    final itemsByCategory = <String, List<MenuItem>>{};
    for (final item in items) {
      final categoryId = _stringValue(item['category_id']);
      if (categoryId == null) {
        continue;
      }

      itemsByCategory.putIfAbsent(categoryId, () => []).add(
            _menuItemFromRecord(item),
          );
    }

    return [
      for (final category in categories)
        MenuCategory(
          id: _stringValue(category['id']) ?? '',
          title: _stringValue(category['name']) ?? 'Categoria',
          items: itemsByCategory[_stringValue(category['id'])] ?? const [],
        ),
    ];
  }

  Establishment _establishmentFromRecord(
    Map<String, dynamic> record,
    Map<String, Map<String, dynamic>> snapshotsByEstablishment,
    int index,
  ) {
    final id = _stringValue(record['id']) ?? 'supabase-$index';
    final slug = _stringValue(record['slug']);
    final fallback = _mockBySlug(slug);
    final availability = snapshotsByEstablishment[id];
    final availableSets = _intValue(availability?['available_sets']);
    final totalSets = _intValue(availability?['total_sets']);

    return Establishment(
      id: id,
      name: _stringValue(record['name']) ?? fallback?.name ?? 'Bar sem nome',
      description: _stringValue(record['description']) ??
          fallback?.description ??
          'Estabelecimento aprovado em Boa Viagem.',
      distanceMeters: fallback?.distanceMeters ?? (180 + index * 160),
      rating: _doubleValue(record['average_rating']) ?? fallback?.rating ?? 0,
      reviewCount:
          _intValue(record['reviews_count']) ?? fallback?.reviewCount ?? 0,
      isOpen: fallback?.isOpen ?? true,
      freeSets: availableSets ?? fallback?.freeSets ?? 0,
      totalSets: totalSets ?? fallback?.totalSets ?? 0,
      cashbackPercent: fallback?.cashbackPercent ?? 0,
      priceRange: fallback?.priceRange ?? r'$$',
      address: _stringValue(record['address']) ??
          _stringValue(record['reference_point']) ??
          fallback?.address ??
          'Boa Viagem, Recife/PE',
      imagePlaceholder: _stringValue(record['reference_point']) ??
          fallback?.imagePlaceholder ??
          'Boa Viagem',
    );
  }

  MenuItem _menuItemFromRecord(Map<String, dynamic> record) {
    final cashbackPercent = _cashbackPercentFromPreview(
      _stringValue(record['cashback_preview_text']),
    );

    return MenuItem(
      id: _stringValue(record['id']) ?? 'supabase-menu-item',
      establishmentId: _stringValue(record['establishment_id']) ?? '',
      categoryId: _stringValue(record['category_id']) ?? '',
      name: _stringValue(record['name']) ?? 'Item sem nome',
      description: _stringValue(record['description']) ??
          'Item publico do cardapio do estabelecimento.',
      price: (_intValue(record['price_cents']) ?? 0) / 100,
      cashbackPercent: cashbackPercent,
      isAvailable: _stringValue(record['status']) != 'unavailable',
      isHighlighted: cashbackPercent != null && cashbackPercent > 0,
    );
  }

  int? _cashbackPercentFromPreview(String? value) {
    if (value == null) {
      return null;
    }

    final match = RegExp(r'(\d+)%').firstMatch(value);
    if (match == null) {
      return null;
    }

    return int.tryParse(match.group(1) ?? '');
  }

  Establishment? _mockBySlug(String? slug) {
    if (slug == null) {
      return null;
    }

    for (final establishment in mockEstablishments) {
      if (establishment.id == slug) {
        return establishment;
      }
    }

    return null;
  }

  String? _stringValue(Object? value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return null;
  }

  int? _intValue(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  double? _doubleValue(Object? value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
