enum FoodCategory {
  meals('Meals', 'Hearty canteen meals & rice plates'),
  beverages('Beverages', 'Refreshing cold & hot drinks'),
  snacks('Snacks', 'Quick bites, rolls & pastries');

  final String displayName;
  final String description;
  const FoodCategory(this.displayName, this.description);
}

class FoodItem {
  final String id;
  final String name;
  final FoodCategory category;
  final double price;
  final String description;
  final String imagePath; // Icon identifier or asset
  final String prepTime;
  final double rating;
  final bool isVegetarian;
  final List<String> tags;

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imagePath,
    this.prepTime = '10-15 mins',
    this.rating = 4.8,
    this.isVegetarian = false,
    this.tags = const [],
  });

  String get formattedPrice => 'LKR ${price.toStringAsFixed(2)}';
}
