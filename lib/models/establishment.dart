class Establishment {
  const Establishment({
    required this.id,
    required this.name,
    required this.description,
    required this.distanceMeters,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.freeSets,
    required this.totalSets,
    required this.cashbackPercent,
    required this.priceRange,
    required this.address,
    required this.imagePlaceholder,
  });

  final String id;
  final String name;
  final String description;
  final int distanceMeters;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final int freeSets;
  final int totalSets;
  final int cashbackPercent;
  final String priceRange;
  final String address;
  final String imagePlaceholder;
}
