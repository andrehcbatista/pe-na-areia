import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.isOpen,
    super.key,
  });

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isOpen ? const Color(0xFFEAF8F2) : AppColors.coralLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            color: isOpen ? AppColors.success : AppColors.danger,
            size: 8,
          ),
          const SizedBox(width: 6),
          Text(
            isOpen ? 'Aberto' : 'Fechado',
            style: TextStyle(
              color: isOpen ? AppColors.success : AppColors.danger,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
