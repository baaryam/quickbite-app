import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  UserProfile? _currentUser;
  final List<FoodItem> _allFoodItems = List.from(MockData.foodItems);
  final List<CartItem> _cartItems = [];
  final List<OrderModel> _orderHistory = [];
  OrderModel? _lastPlacedOrder;

  // Search & Filters
  String _searchQuery = '';
  FoodCategory? _selectedCategory;

  AppState() {
    _seedInitialOrders();
  }

  void _seedInitialOrders() {
    // Seed a couple of realistic previous simulated orders for the student profile
    final sampleItems = [
      CartItem(foodItem: MockData.foodItems[1], quantity: 1), // Fried Rice
      CartItem(foodItem: MockData.foodItems[4], quantity: 2), // Milk Tea
    ];
    const double subtotal = 650.0 + (120.0 * 2);
    _orderHistory.add(
      OrderModel(
        id: 'QB-2041',
        customerName: 'Kobi Perera',
        customerPhone: '+94 77 123 4567',
        pickupLocation: 'Main Canteen - Counter 1',
        estimatedPickupTime: '12:45 PM',
        items: sampleItems,
        subtotal: subtotal,
        serviceFee: 0.0,
        total: subtotal,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        status: OrderStatus.completed,
      ),
    );
  }

  // Auth / User Getters & Methods
  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void login({required String name, required String email, String? studentId}) {
    _currentUser = UserProfile(
      name: name.trim().isEmpty ? 'Student' : name.trim(),
      email: email.trim().isEmpty ? 'student@campus.ac.lk' : email.trim(),
      studentId: (studentId != null && studentId.trim().isNotEmpty)
          ? studentId.trim()
          : 'STU-${Random().nextInt(9000) + 1000}',
      isGuest: false,
    );
    notifyListeners();
  }

  void continueAsGuest() {
    _currentUser = UserProfile.guest();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _cartItems.clear();
    _lastPlacedOrder = null;
    notifyListeners();
  }

  // Food & Filtering Getters
  List<FoodItem> get allFoodItems => _allFoodItems;
  String get searchQuery => _searchQuery;
  FoodCategory? get selectedCategory => _selectedCategory;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectCategory(FoodCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<FoodItem> get filteredFoodItems {
    return _allFoodItems.where((item) {
      final matchesCategory = _selectedCategory == null || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Cart Management
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get cartTotalCount =>
      _cartItems.fold(0, (total, item) => total + item.quantity);

  double get cartSubtotal =>
      _cartItems.fold(0.0, (total, item) => total + item.subtotal);

  double get serviceFee => 0.0; // Free campus pickup

  double get cartGrandTotal => cartSubtotal + serviceFee;

  String get formattedCartSubtotal => 'LKR ${cartSubtotal.toStringAsFixed(2)}';
  String get formattedCartGrandTotal => 'LKR ${cartGrandTotal.toStringAsFixed(2)}';

  int getItemQuantity(String foodId) {
    final index = _cartItems.indexWhere((c) => c.foodItem.id == foodId);
    return index >= 0 ? _cartItems[index].quantity : 0;
  }

  void addToCart(FoodItem item, {int quantity = 1, String? specialInstructions}) {
    final index = _cartItems.indexWhere((c) => c.foodItem.id == item.id);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
      if (specialInstructions != null) {
        _cartItems[index].specialInstructions = specialInstructions;
      }
    } else {
      _cartItems.add(
        CartItem(
          foodItem: item,
          quantity: quantity,
          specialInstructions: specialInstructions,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String foodId, int newQuantity) {
    final index = _cartItems.indexWhere((c) => c.foodItem.id == foodId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String foodId) {
    final index = _cartItems.indexWhere((c) => c.foodItem.id == foodId);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String foodId) {
    final index = _cartItems.indexWhere((c) => c.foodItem.id == foodId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String foodId) {
    _cartItems.removeWhere((c) => c.foodItem.id == foodId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Order Management
  List<OrderModel> get orderHistory => List.unmodifiable(_orderHistory);
  OrderModel? get lastPlacedOrder => _lastPlacedOrder;

  OrderModel? getOrderById(String orderId) {
    try {
      return _orderHistory.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return _lastPlacedOrder?.id == orderId ? _lastPlacedOrder : null;
    }
  }

  OrderModel placeOrder({
    required String pickupLocation,
    required String estimatedPickupTime,
    String? contactPhone,
    String? specialNotes,
  }) {
    final randomNum = Random().nextInt(9000) + 1000;
    final orderId = 'QB-$randomNum';

    final order = OrderModel(
      id: orderId,
      customerName: _currentUser?.name ?? 'Guest Student',
      customerPhone: contactPhone ?? '+94 77 000 0000',
      pickupLocation: pickupLocation,
      estimatedPickupTime: estimatedPickupTime,
      items: List.from(_cartItems),
      subtotal: cartSubtotal,
      serviceFee: serviceFee,
      total: cartGrandTotal,
      createdAt: DateTime.now(),
      specialNotes: specialNotes,
      status: OrderStatus.placed,
    );

    _lastPlacedOrder = order;
    _orderHistory.insert(0, order);
    _cartItems.clear();
    notifyListeners();
    return order;
  }

  void advanceOrderStatus(String orderId) {
    final order = getOrderById(orderId);
    if (order != null) {
      order.advanceStatus();
      notifyListeners();
    }
  }
}
