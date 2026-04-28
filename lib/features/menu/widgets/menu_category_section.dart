import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../models/menu_category.dart';
import 'menu_item_card.dart';

class MenuCategorySection extends StatelessWidget {
  const MenuCategorySection({
    required this.category,
    super.key,
  });

  final MenuCategory category;

  @override
  Widget build(BuildContext context) {
    if (category.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.title, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        for (final item in category.items) ...[
          MenuItemCard(item: item),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
