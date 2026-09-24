import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import '../widgets/order_status_stepper.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Live Order Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Simulate Next Status',
            onPressed: () {
              final appState = Provider.of<AppState>(context, listen: false);
              appState.advanceOrderStatus(orderId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Simulated: Order status advanced!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final order = appState.getOrderById(orderId);

          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Order not found'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text('BACK TO MENU'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveLayout.getMaxContentWidth(context),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ResponsiveLayout(
                  mobile: _buildTrackingContent(context, appState, order),
                  tablet: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _buildTrackingContent(context, appState, order)),
                      const SizedBox(width: 24),
                      Expanded(flex: 4, child: _buildOrderDetailsCard(order)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackingContent(BuildContext context, AppState appState, OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Order Header Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Reference',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          order.id,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryDark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _getStatusColor(order.status).withOpacity(0.4)),
                      ),
                      child: Text(
                        order.status.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppTheme.borderLight),
                const SizedBox(height: 12),

                // Pickup location and estimated time info
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 20, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.pickupLocation,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 20, color: AppTheme.secondaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Estimated Pickup: ${order.estimatedPickupTime}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Live Stepper Card
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.timeline_rounded, color: AppTheme.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Live Kitchen Progress',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                OrderStatusStepper(currentStatus: order.status),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Simulation Controller Card for Testing / Evaluation
        Card(
          color: const Color(0xFFF1F5F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Icon(Icons.science_outlined, size: 20, color: AppTheme.secondaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Kitchen Status Simulator',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.secondaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tap below to simulate kitchen preparation stages (Placed ➔ Preparing ➔ Ready for pickup).',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: order.status == OrderStatus.completed || order.status == OrderStatus.readyForPickup
                      ? null
                      : () {
                          appState.advanceOrderStatus(order.id);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.fast_forward_rounded, size: 18),
                  label: Text(
                    order.status == OrderStatus.placed
                        ? 'Simulate Kitchen ➔ "Preparing"'
                        : (order.status == OrderStatus.preparing
                            ? 'Simulate Kitchen ➔ "Ready for Pickup"'
                            : 'Order Ready at Counter'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Mobile order summary details
        if (ResponsiveLayout.isMobile(context)) _buildOrderDetailsCard(order),
        const SizedBox(height: 20),

        // Back to Home Button
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Back to Home Menu'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildOrderDetailsCard(OrderModel order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fastfood_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Ordered Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Items List
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.foodItem.name}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                        ),
                      ),
                      Text(
                        item.formattedSubtotal,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )),
            const Divider(color: AppTheme.borderLight, height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Paid / Due',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
                Text(
                  order.formattedTotal,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.primaryDark),
                ),
              ],
            ),
            if (order.specialNotes != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Text(
                  'Note: "${order.specialNotes}"',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return AppTheme.primaryColor;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.readyForPickup:
        return AppTheme.successGreen;
      case OrderStatus.completed:
        return AppTheme.secondaryColor;
    }
  }
}
