import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CashbackBadge extends StatelessWidget {
  const CashbackBadge({
    required this.percent,
    super.key,
  });

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.coralLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$percent% cashback',
        style: const TextStyle(
          color: AppColors.coral,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
