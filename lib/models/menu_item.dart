class MenuItem {
  const MenuItem({
    required this.id,
    required this.establishmentId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.brand,
    this.cashbackPercent,
    this.isAvailable = true,
    this.isHighlighted = false,
  });

  final String id;
  final String establishmentId;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final String? brand;
  final int? cashbackPercent;
  final bool isAvailable;
  final bool isHighlighted;
}
