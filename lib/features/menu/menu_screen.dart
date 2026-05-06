import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_establishments.dart';
import '../../data/mock/mock_menu_items.dart';
import '../../models/establishment.dart';
import '../../shared/widgets/coming_soon_dialog.dart';
import '../../shared/widgets/primary_button.dart';
import 'widgets/menu_category_section.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final establishment = _establishmentFromRoute(context);
    final categories = menuForEstablishment(establishment.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Cardápio')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(establishment.name, style: AppTextStyles.title),
            const SizedBox(height: 6),
            const Text(
              'Produtos mockados para validar a consulta pública do MVP 1.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 20),
            for (final category in categories) ...[
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
