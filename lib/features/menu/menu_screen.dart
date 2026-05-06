import 'package:flutter/material.dart';

import '../../core/services/supabase_client_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_establishments.dart';
import '../../data/mock/mock_menu_items.dart';
import '../../data/repositories/supabase_public_data_repository.dart';
import '../../models/establishment.dart';
import '../../models/menu_category.dart';
import '../../shared/widgets/coming_soon_dialog.dart';
import '../../shared/widgets/primary_button.dart';
import 'widgets/menu_category_section.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Establishment? _establishment;
  List<MenuCategory> _categories = const [];
  String? _fallbackMessage;
  bool _loadedRoute = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedRoute) {
      return;
    }

    _loadedRoute = true;
    final establishment = _establishmentFromRoute(context);
    _establishment = establishment;
    _categories = menuForEstablishment(establishment.id);
    _loadSupabaseMenu(establishment.id);
  }

  Future<void> _loadSupabaseMenu(String establishmentId) async {
    if (!SupabaseClientService.isConfigured ||
        !_looksLikeUuid(establishmentId)) {
      return;
    }

    try {
      final categories =
          await SupabasePublicDataRepository().fetchMenuForEstablishment(
        establishmentId,
      );

      if (!mounted || categories.isEmpty || !_hasVisibleItems(categories)) {
        return;
      }

      setState(() {
        _categories = categories;
        _fallbackMessage = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _fallbackMessage =
            'N\u00E3o foi poss\u00EDvel carregar o card\u00E1pio real agora. Exibindo os dados locais.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final establishment = _establishment ?? mockEstablishments.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Card\u00E1pio')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(establishment.name, style: AppTextStyles.title),
            const SizedBox(height: 6),
            const Text(
              'Produtos p\u00FAblicos quando dispon\u00EDveis, com fallback local para o MVP 1.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 20),
            if (_fallbackMessage != null) ...[
              _FallbackNotice(message: _fallbackMessage!),
              const SizedBox(height: 14),
            ],
            for (final category in _categories) ...[
              MenuCategorySection(category: category),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 10),
            PrimaryButton(
              label: 'Pedidos em breve',
              icon: Icons.room_service_rounded,
              onPressed: () => ComingSoonDialog.show(
                context,
                featureName: 'Pedidos',
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasVisibleItems(List<MenuCategory> categories) {
    return categories.any((category) => category.items.isNotEmpty);
  }

  bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  Establishment _establishmentFromRoute(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Establishment) {
      return arguments;
    }

    final id = arguments is String ? arguments : null;
    return mockEstablishments.firstWhere(
      (establishment) => establishment.id == id,
      orElse: () => mockEstablishments.first,
    );
  }
}

class _FallbackNotice extends StatelessWidget {
  const _FallbackNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.oceanLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.oceanDark,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.oceanDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
