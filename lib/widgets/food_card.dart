import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'food_image_widget.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            Stack(
              children: [
                FoodImageWidget(
                  item: item,
                  height: 125,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppTheme.accentColor),
                        const SizedBox(width: 2),
                        Text(
                          item.rating.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Item Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    // Price and Add button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            item.formattedPrice,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                        ),
                        Consumer<AppState>(
                          builder: (context, appState, child) {
                            final qty = appState.getItemQuantity(item.id);
                            return SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: qty > 0 ? AppTheme.secondaryColor : AppTheme.primaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  appState.addToCart(item, quantity: 1);
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added 1x ${item.name} to cart!'),
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: 'VIEW CART',
                                        textColor: Colors.amberAccent,
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/cart');
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      qty > 0 ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      qty > 0 ? '$qty in cart' : 'Add',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
