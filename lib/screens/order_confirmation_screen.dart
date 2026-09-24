import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import 'order_tracking_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String? orderId;

  const OrderConfirmationScreen({
    super.key,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOrderId = orderId ??
        (ModalRoute.of(context)?.settings.arguments as String?) ??
        '';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Order Placed'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final order = appState.getOrderById(effectiveOrderId) ?? appState.lastPlacedOrder;

          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No order details found.'),
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
                maxWidth: ResponsiveLayout.isTablet(context) || ResponsiveLayout.isDesktop(context) ? 540 : double.infinity,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Success Icon & Card
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                size: 54,
                                color: AppTheme.successGreen,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Order Received!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Your meal request is being prepared at the canteen.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(color: AppTheme.borderLight),
                            const SizedBox(height: 18),

                            // Order Number badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'CAMPUS ORDER NUMBER',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.id,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Order Info Rows
                            _buildInfoRow('Order Total', order.formattedTotal, isBold: true, isPrice: true),
                            const SizedBox(height: 10),
                            _buildInfoRow('Pickup Location', order.pickupLocation),
                            const SizedBox(height: 10),
                            _buildInfoRow('Estimated Time', order.estimatedPickupTime),
                            const SizedBox(height: 10),
                            _buildInfoRow('Total Items', '${order.totalItemCount} item(s)'),
                            const SizedBox(height: 10),
                            _buildInfoRow('Customer', order.customerName),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderTrackingScreen(orderId: order.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.track_changes_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'TRACK ORDER STATUS',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Back to Home Menu',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isPrice ? AppTheme.primaryDark : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
