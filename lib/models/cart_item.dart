import 'food_item.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;
  String? specialInstructions;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
    this.specialInstructions,
  });

  double get subtotal => foodItem.price * quantity;
  String get formattedSubtotal => 'LKR ${subtotal.toStringAsFixed(2)}';
  String get formattedUnitPrice => foodItem.formattedPrice;
}
