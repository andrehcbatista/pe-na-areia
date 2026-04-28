import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/menu_item.dart';
import '../../../shared/widgets/cashback_badge.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    required this.item,
    super.key,
  });

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: item.isHighlighted
                      ? AppColors.coralLight
                      : AppColors.oceanLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item.isHighlighted
                      ? Icons.local_fire_department_rounded
                      : Icons.restaurant_menu_rounded,
                  color: item.isHighlighted ? AppColors.coral : AppColors.ocean,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: AppTextStyles.body),
                    if (item.brand != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.brand!,
                        style: const TextStyle(
                          color: AppColors.violet,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(item.description, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                Formatters.currency(item.price),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _MenuItemAvailabilityChip(isAvailable: item.isAvailable),
              if (item.cashbackPercent != null)
                CashbackBadge(percent: item.cashbackPercent!),
              _MenuItemActionButton(
                onPressed: () => _showOrdersComingSoon(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOrdersComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Pedidos estar\u00E3o dispon\u00EDveis na pr\u00F3xima etapa do P\u00E9 na Areia.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _MenuItemAvailabilityChip extends StatelessWidget {
  const _MenuItemAvailabilityChip({
    required this.isAvailable,
  });

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? AppColors.success : AppColors.danger;
    final background =
        isAvailable ? const Color(0xFFEAF8F2) : AppColors.coralLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 8),
          const SizedBox(width: 6),
          Text(
            isAvailable ? 'Dispon\u00EDvel' : 'Indispon\u00EDvel',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemActionButton extends StatelessWidget {
  const _MenuItemActionButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_rounded, size: 17),
        label: const Text('Em breve'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.oceanDark,
          side: const BorderSide(color: AppColors.border),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
