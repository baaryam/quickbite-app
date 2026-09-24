import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import '../widgets/food_image_widget.dart';
import '../widgets/quantity_button.dart';

class ItemDetailScreen extends StatefulWidget {
  final FoodItem item;

  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.addToCart(
      widget.item,
      quantity: _quantity,
      specialInstructions: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity x ${widget.item.name} to cart!'),
        backgroundColor: AppTheme.secondaryColor,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'GO TO CART',
          textColor: Colors.amberAccent,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final itemTotal = widget.item.price * _quantity;
    final formattedItemTotal = 'LKR ${itemTotal.toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    tooltip: 'Cart',
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (appState.cartTotalCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${appState.cartTotalCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getMaxContentWidth(context),
          ),
          child: ResponsiveLayout(
            mobile: _buildMobileLayout(formattedItemTotal),
            tablet: _buildTabletLayout(formattedItemTotal),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(formattedItemTotal),
    );
  }

  Widget _buildMobileLayout(String formattedItemTotal) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Large Hero Food Image
          FoodImageWidget(
            item: widget.item,
            height: 250,
            isDetail: true,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildItemInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(String formattedItemTotal) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: FoodImageWidget(
              item: widget.item,
              height: 360,
              isDetail: true,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 6,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildItemInfo(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category and Rating row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.item.category.displayName.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 22),
                const SizedBox(width: 4),
                Text(
                  widget.item.rating.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '(120+ ratings)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Item Name
        Text(
          widget.item.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Unit Price
        Text(
          widget.item.formattedPrice,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: AppTheme.borderLight),
        const SizedBox(height: 16),

        // Description
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.item.description,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Tags
        if (widget.item.tags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.item.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Text(
                  '# $tag',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Special Instructions
        const Text(
          'Special Instructions (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'e.g. Less spicy, extra sauce, no cutlery...',
            contentPadding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(String formattedItemTotal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity Selector
            QuantityButton(
              quantity: _quantity,
              onIncrement: _increment,
              onDecrement: _decrement,
              isLarge: true,
            ),
            const SizedBox(width: 16),

            // Add to Cart Button with total
            Expanded(
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shopping_bag_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formattedItemTotal,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
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
