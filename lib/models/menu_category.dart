import 'menu_item.dart';

class MenuCategory {
  const MenuCategory({
    required this.id,
    required this.title,
    required this.items,
  });

  final String id;
  final String title;
  final List<MenuItem> items;
}
