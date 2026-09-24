import '../models/food_item.dart';

class MockData {
  static const List<FoodItem> foodItems = [
    // Meals
    FoodItem(
      id: 'm1',
      name: 'Rice & Curry',
      category: FoodCategory.meals,
      price: 450.00,
      description:
          'Traditional Sri Lankan canteen plate with steamed fragrant rice, creamy dhal curry, 3 seasonal vegetable curries, crispy papadam, and your choice of chili sambol.',
      imagePath: 'rice_curry',
      prepTime: '5-10 mins',
      rating: 4.9,
      isVegetarian: false,
      tags: ['Popular', 'Authentic', 'Spicy'],
    ),
    FoodItem(
      id: 'm2',
      name: 'Chicken Fried Rice',
      category: FoodCategory.meals,
      price: 650.00,
      description:
          'Wok-tossed aromatic basmati rice tossed with shredded marinated chicken, farm eggs, crisp garden leeks, carrots, and served with spicy chili paste.',
      imagePath: 'fried_rice',
      prepTime: '10-15 mins',
      rating: 4.8,
      isVegetarian: false,
      tags: ['Chef Special', 'Best Seller'],
    ),
    FoodItem(
      id: 'm3',
      name: 'Chicken Kottu',
      category: FoodCategory.meals,
      price: 750.00,
      description:
          'Freshly chopped godamba roti griddled on hot steel plates with succulent chicken, farm-fresh eggs, onions, green chilies, and rich aromatic curry gravy.',
      imagePath: 'kottu',
      prepTime: '12-15 mins',
      rating: 4.9,
      isVegetarian: false,
      tags: ['Campus Favorite', 'Hot & Spicy'],
    ),
    FoodItem(
      id: 'm4',
      name: 'Stir-Fried Noodles',
      category: FoodCategory.meals,
      price: 550.00,
      description:
          'Savory egg noodles tossed in a sizzling wok with julienned vegetables, scrambled egg, garlic, and our signature savory canteen soy-chili sauce.',
      imagePath: 'noodles',
      prepTime: '8-12 mins',
      rating: 4.7,
      isVegetarian: true,
      tags: ['Quick Prep', 'Veg Option'],
    ),

    // Beverages
    FoodItem(
      id: 'b1',
      name: 'Ceylon Milk Tea',
      category: FoodCategory.beverages,
      price: 120.00,
      description:
          'Authentic freshly brewed strong Ceylon highland black tea blended with rich condensed milk, subtle cardamom, and served piping hot.',
      imagePath: 'milk_tea',
      prepTime: '2-5 mins',
      rating: 4.9,
      isVegetarian: true,
      tags: ['Morning Essential', 'Hot'],
    ),
    FoodItem(
      id: 'b2',
      name: 'Fresh Juice',
      category: FoodCategory.beverages,
      price: 250.00,
      description:
          'Chilled, 100% natural freshly squeezed tropical seasonal fruit juice (Mango / Passion Fruit / Lime) served with crushed ice and fresh mint.',
      imagePath: 'fresh_juice',
      prepTime: '3-5 mins',
      rating: 4.8,
      isVegetarian: true,
      tags: ['Refreshing', 'Chilled', 'Vitamin C'],
    ),
    FoodItem(
      id: 'b3',
      name: 'Campus Iced Coffee',
      category: FoodCategory.beverages,
      price: 300.00,
      description:
          'Double shot of rich roasted espresso shaken with chilled creamy milk, Madagascar vanilla syrup, and topped with chocolate drizzle.',
      imagePath: 'coffee',
      prepTime: '3-5 mins',
      rating: 4.7,
      isVegetarian: true,
      tags: ['Energy Boost', 'Iced'],
    ),

    // Snacks
    FoodItem(
      id: 's1',
      name: 'Vegetable Samosa',
      category: FoodCategory.snacks,
      price: 160.00,
      description:
          'Pair of golden crispy triangular pastries packed with spiced potatoes, green peas, cumin, coriander, and served with tangy tamarind dip.',
      imagePath: 'samosa',
      prepTime: '1-3 mins',
      rating: 4.6,
      isVegetarian: true,
      tags: ['Crispy', 'Snack Pack (2 pcs)'],
    ),
    FoodItem(
      id: 's2',
      name: 'Fish & Egg Roll',
      category: FoodCategory.snacks,
      price: 180.00,
      description:
          'Crunchy breadcrumbed Chinese-style roll stuffed with spiced wild mackerel, potato mash, black pepper, and hard-boiled egg.',
      imagePath: 'roll',
      prepTime: '1-3 mins',
      rating: 4.8,
      isVegetarian: false,
      tags: ['Crispy', 'Spicy Bite'],
    ),
    FoodItem(
      id: 's3',
      name: 'Toasted Club Sandwich',
      category: FoodCategory.snacks,
      price: 380.00,
      description:
          'Triple-layer toasted sandwich stuffed with seasoned shredded chicken, cheddar cheese slice, fresh crunchy lettuce, sliced tomatoes, and mayo.',
      imagePath: 'sandwich',
      prepTime: '5-8 mins',
      rating: 4.7,
      isVegetarian: false,
      tags: ['Toasted', 'Filling'],
    ),
  ];
}
