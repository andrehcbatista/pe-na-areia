import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_establishments.dart';
import '../../models/establishment.dart';
import '../../shared/widgets/availability_chip.dart';
import '../../shared/widgets/cashback_badge.dart';
import '../../shared/widgets/coming_soon_dialog.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/secondary_button.dart';
import '../../shared/widgets/status_badge.dart';

class EstablishmentDetailScreen extends StatelessWidget {
  const EstablishmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final establishment = _establishmentFromRoute(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(establishment.name),
        actions: [
          IconButton(
            tooltip: 'QR Code em breve',
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () => ComingSoonDialog.show(
              context,
              featureName: 'QR Code',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _HeroPlaceholder(establishment: establishment),
            const SizedBox(height: 18),
            Text(establishment.name, style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(establishment.description, style: AppTextStyles.bodyMuted),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusBadge(isOpen: establishment.isOpen),
                AvailabilityChip(
                  freeSets: establishment.freeSets,
                  totalSets: establishment.totalSets,
                ),
                CashbackBadge(percent: establishment.cashbackPercent),
              ],
            ),
            const SizedBox(height: 18),
            _InfoPanel(establishment: establishment),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Ver cardápio',
              icon: Icons.menu_book_rounded,
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.menu,
                arguments: establishment,
              ),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: 'Pedidos em breve',
              icon: Icons.room_service_rounded,
              onPressed: () => ComingSoonDialog.show(
                context,
                featureName: 'Pedidos',
              ),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: 'Comanda em breve',
              icon: Icons.receipt_long_rounded,
              onPressed: () => ComingSoonDialog.show(
                context,
                featureName: 'Comanda',
              ),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: 'Reservas em breve',
              icon: Icons.event_available_rounded,
              onPressed: () => ComingSoonDialog.show(
                context,
                featureName: 'Reservas',
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

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder({required this.establishment});

  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    final compactWidth = MediaQuery.sizeOf(context).width < 360;

    return Container(
      height: compactWidth ? 190 : 220,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ocean, AppColors.violet],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.beach_access_rounded, color: Colors.white, size: 42),
          const Spacer(),
          Text(
            establishment.imagePlaceholder,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            establishment.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.establishment});

  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.star_rounded,
            label: 'Reputação',
            value: '',
            trailing: RatingStars(
              rating: establishment.rating,
              reviewCount: establishment.reviewCount,
            ),
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.near_me_rounded,
            label: 'Distância simulada',
            value: Formatters.meters(establishment.distanceMeters),
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.payments_rounded,
            label: 'Faixa de preço',
            value: establishment.priceRange,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.place_rounded,
            label: 'Endereço',
            value: establishment.address,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.ocean),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMuted),
        ),
        trailing ??
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
      ],
    );
  }
}
