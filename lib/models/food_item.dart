class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final bool isLive;
  final String? favoriteId;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.isLive = false,
    this.favoriteId,
  });
}
