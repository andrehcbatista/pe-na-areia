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
      appBar: AppBar(title: Text('Cardapio')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            Text(establishment.name, style: AppTextStyles.title),
            const SizedBox(height: 6),
            const Text(
              'Produtos mockados para validar a consulta publica do MVP.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 20),
            for (final category in categories) ...[
              MenuCategorySection(category: category),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 10),
            PrimaryButton(
              label: 'Fazer pedido',
              icon: Icons.room_service_rounded,
              onPressed: () => ComingSoonDialog.show(
                context,
                featureName: 'Fazer pedido',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Establishment _establishmentFromRoute(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    return mockEstablishments.firstWhere(
      (establishment) => establishment.id == id,
      orElse: () => mockEstablishments.first,
    );
  }
}
