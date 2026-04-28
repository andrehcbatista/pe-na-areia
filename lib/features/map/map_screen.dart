import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_establishments.dart';
import '../home/widgets/establishment_card.dart';
import '../home/widgets/mock_map_preview.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de estabelecimentos')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            MockMapPreview(
              establishments: mockEstablishments,
              expanded: true,
            ),
            const SizedBox(height: 20),
            const Text('Bares proximos', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            for (final establishment in mockEstablishments) ...[
              EstablishmentCard(
                establishment: establishment,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.establishmentDetail,
                  arguments: establishment.id,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
