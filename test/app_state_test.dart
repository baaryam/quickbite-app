import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite_app/models/food_item.dart';
import 'package:quickbite_app/models/order.dart';
import 'package:quickbite_app/providers/app_state.dart';
import 'package:quickbite_app/data/mock_data.dart';

void main() {
  group('AppState Business Logic Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('Initial state contains mock food items and empty cart', () {
      expect(appState.allFoodItems.isNotEmpty, true);
      expect(appState.cartItems.isEmpty, true);
      expect(appState.cartTotalCount, 0);
      expect(appState.cartSubtotal, 0.0);
    });

    test('Authentication and Guest mode work correctly', () {
      appState.login(
        name: 'Kasun Bandara',
        email: 'kasun.b@campus.ac.lk',
        studentId: 'STU-2026-4412',
      );
      expect(appState.isAuthenticated, true);
      expect(appState.currentUser?.name, 'Kasun Bandara');
      expect(appState.currentUser?.isGuest, false);

      appState.continueAsGuest();
      expect(appState.currentUser?.name, 'Guest Student');
      expect(appState.currentUser?.isGuest, true);

      appState.logout();
      expect(appState.currentUser, null);
      expect(appState.isAuthenticated, false);
    });

    test('Category filtering and search work accurately', () {
      appState.selectCategory(FoodCategory.meals);
      expect(appState.filteredFoodItems.every((item) => item.category == FoodCategory.meals), true);

      appState.setSearchQuery('Fried Rice');
      expect(appState.filteredFoodItems.length, 1);
      expect(appState.filteredFoodItems.first.name, 'Chicken Fried Rice');

      appState.setSearchQuery('');
      appState.selectCategory(null);
      expect(appState.filteredFoodItems.length, MockData.foodItems.length);
    });

    test('Add to Cart, Increment, Decrement, and Subtotal calculations', () {
      final rice = MockData.foodItems[0]; // Rice & Curry (450.00)
      final tea = MockData.foodItems[4]; // Ceylon Milk Tea (120.00)

      appState.addToCart(rice, quantity: 2);
      expect(appState.cartTotalCount, 2);
      expect(appState.cartSubtotal, 900.00);

      appState.addToCart(tea, quantity: 1);
      expect(appState.cartTotalCount, 3);
      expect(appState.cartSubtotal, 1020.00);

      // Increment
      appState.incrementQuantity(rice.id);
      expect(appState.getItemQuantity(rice.id), 3);
      expect(appState.cartSubtotal, 1470.00);

      // Decrement
      appState.decrementQuantity(tea.id); // was 1, should now be removed
      expect(appState.getItemQuantity(tea.id), 0);
      expect(appState.cartTotalCount, 3);
      expect(appState.cartSubtotal, 1350.00);

      // Clear cart
      appState.clearCart();
      expect(appState.cartItems.isEmpty, true);
      expect(appState.cartTotalCount, 0);
      expect(appState.cartSubtotal, 0.0);
    });

    test('Order placement and tracking state advancement', () {
      final kottu = MockData.foodItems[2]; // Chicken Kottu (750.00)
      appState.addToCart(kottu, quantity: 1);

      final order = appState.placeOrder(
        pickupLocation: 'Main Canteen - Counter 1',
        estimatedPickupTime: '12:30 PM',
        contactPhone: '+94 77 123 4567',
        specialNotes: 'Extra spicy please',
      );

      expect(order.id.startsWith('QB-'), true);
      expect(order.status, OrderStatus.placed);
      expect(order.total, 750.00);
      expect(appState.cartItems.isEmpty, true); // Cart should be cleared

      // Advance status 1: Placed -> Preparing
      appState.advanceOrderStatus(order.id);
      expect(order.status, OrderStatus.preparing);

      // Advance status 2: Preparing -> Ready for pickup
      appState.advanceOrderStatus(order.id);
      expect(order.status, OrderStatus.readyForPickup);

      // Advance status 3: Ready for pickup -> Completed
      appState.advanceOrderStatus(order.id);
      expect(order.status, OrderStatus.completed);
    });
  });
}
