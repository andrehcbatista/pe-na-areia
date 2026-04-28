import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/establishment.dart';
import '../../../shared/widgets/availability_chip.dart';
import '../../../shared/widgets/cashback_badge.dart';
import '../../../shared/widgets/rating_stars.dart';
import '../../../shared/widgets/status_badge.dart';

class EstablishmentCard extends StatelessWidget {
  const EstablishmentCard({
    required this.establishment,
    required this.onTap,
    super.key,
  });

  final Establishment establishment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stackContent = constraints.maxWidth < 330;

              if (stackContent) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ImagePlaceholder(
                      label: establishment.imagePlaceholder,
                      wide: true,
                    ),
                    const SizedBox(height: 12),
                    _EstablishmentSummary(establishment: establishment),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ImagePlaceholder(label: establishment.imagePlaceholder),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _EstablishmentSummary(establishment: establishment),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EstablishmentSummary extends StatelessWidget {
  const _EstablishmentSummary({required this.establishment});

  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          establishment.name,
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(height: 4),
        RatingStars(
          rating: establishment.rating,
          reviewCount: establishment.reviewCount,
          compact: true,
        ),
        const SizedBox(height: 8),
        Text(
          establishment.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMuted,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 7,
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
        const SizedBox(height: 10),
        Text(
          '${Formatters.meters(establishment.distanceMeters)} - ${establishment.priceRange}',
          style: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({
    required this.label,
    this.wide = false,
  });

  final String label;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? double.infinity : 76,
      height: wide ? 112 : 96,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ocean, AppColors.violet],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          label,
          maxLines: wide ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
