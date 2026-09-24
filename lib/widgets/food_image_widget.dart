import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodImageWidget extends StatelessWidget {
  final FoodItem item;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isDetail;

  const FoodImageWidget({
    super.key,
    required this.item,
    this.width,
    this.height,
    this.borderRadius,
    this.isDetail = false,
  });

  IconData _getCategoryIcon() {
    switch (item.imagePath) {
      case 'rice_curry':
        return Icons.dinner_dining_rounded;
      case 'fried_rice':
        return Icons.rice_bowl_rounded;
      case 'kottu':
        return Icons.ramen_dining_rounded;
      case 'noodles':
        return Icons.soup_kitchen_rounded;
      case 'milk_tea':
        return Icons.emoji_food_beverage_rounded;
      case 'fresh_juice':
        return Icons.local_bar_rounded;
      case 'coffee':
        return Icons.coffee_rounded;
      case 'samosa':
        return Icons.bakery_dining_rounded;
      case 'roll':
        return Icons.breakfast_dining_rounded;
      case 'sandwich':
        return Icons.lunch_dining_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

  List<Color> _getGradients() {
    switch (item.category) {
      case FoodCategory.meals:
        return [const Color(0xFFFF7A00), const Color(0xFFE52E71)];
      case FoodCategory.beverages:
        return [const Color(0xFF00C6FF), const Color(0xFF0072FF)];
      case FoodCategory.snacks:
        return [const Color(0xFFF7971E), const Color(0xFFFFD200)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradients = _getGradients();
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? (isDetail ? 240 : 130),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradients,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative background patterns
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: isDetail ? 180 : 100,
                height: isDetail ? 180 : 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              left: -10,
              top: -10,
              child: Container(
                width: isDetail ? 120 : 60,
                height: isDetail ? 120 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            // Center Food Icon & Label
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(isDetail ? 24 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    size: isDetail ? 68 : 42,
                    color: Colors.white,
                  ),
                ),
                if (isDetail) const SizedBox(height: 10),
                if (isDetail)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.category.displayName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
            // Vegetarian / Prep Time badges
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.isVegetarian ? Icons.eco_rounded : Icons.local_fire_department_rounded,
                      size: 13,
                      color: item.isVegetarian ? Colors.greenAccent : Colors.orangeAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.isVegetarian ? 'Veg' : 'Chef Pick',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 12, color: Colors.white70),
                    const SizedBox(width: 3),
                    Text(
                      item.prepTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
