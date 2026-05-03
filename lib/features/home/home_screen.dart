import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_beaches.dart';
import '../../data/mock/mock_establishments.dart';
import '../../shared/widgets/coming_soon_dialog.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/secondary_button.dart';
import 'widgets/beach_header.dart';
import 'widgets/establishment_card.dart';
import 'widgets/mock_map_preview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir bares'),
        actions: [
          IconButton(
            tooltip: 'QR Code em breve',
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () => ComingSoonDialog.show(
              context,
              featureName: 'QR Code',
            ),
          ),
          IconButton(
            tooltip: 'Admin mockado',
            icon: const Icon(Icons.admin_panel_settings_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.adminRequests);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            BeachHeader(beach: boaViagemBeach),
            const SizedBox(height: 16),
            MockMapPreview(
              establishments: mockEstablishments,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.map),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final stackButtons = constraints.maxWidth < 360;
                final mapButton = SecondaryButton(
                  label: 'Ver mapa',
                  icon: Icons.map_rounded,
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.map,
                  ),
                );
                final signupButton = SecondaryButton(
                  label: 'Cadastrar bar',
                  icon: Icons.storefront_rounded,
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.establishmentSignup,
                  ),
                );

                if (stackButtons) {
                  return Column(
                    children: [
                      mapButton,
                      const SizedBox(height: 10),
                      signupButton,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: mapButton),
                    const SizedBox(width: 10),
                    Expanded(child: signupButton),
                  ],
                );
              },
            ),
            const SizedBox(height: 22),
            const Text(
              'Bares na faixa de areia',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 6),
            const Text(
              'Dados locais para validar descoberta, cardápio, distância e disponibilidade.',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 14),
            for (final establishment in mockEstablishments) ...[
              EstablishmentCard(
                establishment: establishment,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.establishmentDetail,
                    arguments: establishment.id,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Abrir Admin mockado',
              icon: Icons.fact_check_rounded,
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.adminRequests,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sem login, pagamento, pedido real, reserva real ou integração externa nesta etapa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
