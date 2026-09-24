import 'cart_item.dart';

enum OrderStatus {
  placed('Placed', 'Order received by canteen kitchen', 0),
  preparing('Preparing', 'Chef is cooking your fresh meal', 1),
  readyForPickup('Ready for pickup', 'Ready for collection at counter', 2),
  completed('Completed', 'Collected by student', 3);

  final String label;
  final String description;
  final int stepIndex;
  const OrderStatus(this.label, this.description, this.stepIndex);
}

class OrderModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String pickupLocation;
  final String estimatedPickupTime;
  final List<CartItem> items;
  final double subtotal;
  final double serviceFee;
  final double total;
  final DateTime createdAt;
  final String? specialNotes;
  OrderStatus status;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.pickupLocation,
    required this.estimatedPickupTime,
    required this.items,
    required this.subtotal,
    this.serviceFee = 0.0,
    required this.total,
    required this.createdAt,
    this.specialNotes,
    this.status = OrderStatus.placed,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
  String get formattedTotal => 'LKR ${total.toStringAsFixed(2)}';
  String get formattedSubtotal => 'LKR ${subtotal.toStringAsFixed(2)}';

  void advanceStatus() {
    switch (status) {
      case OrderStatus.placed:
        status = OrderStatus.preparing;
        break;
      case OrderStatus.preparing:
        status = OrderStatus.readyForPickup;
        break;
      case OrderStatus.readyForPickup:
        status = OrderStatus.completed;
        break;
      case OrderStatus.completed:
        break;
    }
  }
}
