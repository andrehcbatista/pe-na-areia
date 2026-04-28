import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AvailabilityChip extends StatelessWidget {
  const AvailabilityChip({
    required this.freeSets,
    required this.totalSets,
    super.key,
  });

  final int freeSets;
  final int totalSets;

  @override
  Widget build(BuildContext context) {
    final hasAvailability = freeSets > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: hasAvailability ? AppColors.oceanLight : AppColors.coralLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$freeSets/$totalSets conjuntos',
        style: TextStyle(
          color: hasAvailability ? AppColors.oceanDark : AppColors.coral,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
