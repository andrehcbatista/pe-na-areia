import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/beach.dart';

class BeachHeader extends StatelessWidget {
  const BeachHeader({
    required this.beach,
    this.trailing,
    super.key,
  });

  final Beach beach;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Praia selecionada',
                  style: AppTextStyles.caption,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${beach.name} — ${beach.city}/${beach.state}',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 8),
          Text(beach.description, style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
