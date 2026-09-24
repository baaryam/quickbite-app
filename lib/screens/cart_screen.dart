import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import '../widgets/food_image_widget.dart';
import '../widgets/quantity_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Canteen Tray'),
        actions: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              if (appState.cartItems.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear Cart?'),
                      content: const Text('Are you sure you want to remove all items from your canteen tray?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            appState.clearCart();
                            Navigator.pop(ctx);
                          },
                          child: const Text('CLEAR ALL', style: TextStyle(color: AppTheme.errorRed)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Clear All', style: TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.w600)),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final items = appState.cartItems;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your tray is currently empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore today’s canteen menu and add some delicious food & beverages!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.restaurant_menu_rounded),
                      label: const Text('BROWSE MENU'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveLayout.getMaxContentWidth(context),
              ),
              child: ResponsiveLayout(
                mobile: _buildMobileCart(context, appState),
                tablet: _buildTabletCart(context, appState),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileCart(BuildContext context, AppState appState) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: appState.cartItems.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cartItem = appState.cartItems[index];
              return _buildCartItemCard(context, appState, cartItem);
            },
          ),
        ),
        _buildOrderSummary(context, appState),
      ],
    );
  }

  Widget _buildTabletCart(BuildContext context, AppState appState) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: ListView.separated(
              itemCount: appState.cartItems.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cartItem = appState.cartItems[index];
                return _buildCartItemCard(context, appState, cartItem);
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 5,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: _buildSummaryContent(context, appState),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, AppState appState, CartItem cartItem) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 75,
                height: 75,
                child: FoodImageWidget(
                  item: cartItem.foodItem,
                  height: 75,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.foodItem.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => appState.removeFromCart(cartItem.foodItem.id),
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Unit: ${cartItem.formattedUnitPrice}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (cartItem.specialInstructions != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Note: "${cartItem.specialInstructions}"',
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),

                  // Quantity Controls & Item Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuantityButton(
                        quantity: cartItem.quantity,
                        onIncrement: () => appState.incrementQuantity(cartItem.foodItem.id),
                        onDecrement: () => appState.decrementQuantity(cartItem.foodItem.id),
                      ),
                      Flexible(
                        child: Text(
                          cartItem.formattedSubtotal,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, AppState appState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: _buildSummaryContent(context, appState),
      ),
    );
  }

  Widget _buildSummaryContent(BuildContext context, AppState appState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Total Items (${appState.cartTotalCount} items)',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              appState.formattedCartSubtotal,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Canteen Pickup Fee',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'FREE (Rs. 0.00)',
              style: TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
        const Divider(height: 20, color: AppTheme.borderLight),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              appState.formattedCartGrandTotal,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/checkout');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppTheme.primaryColor,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CHECKOUT',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}
