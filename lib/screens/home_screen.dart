import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Consumer<AppState>(
          builder: (context, appState, child) {
            final userName = appState.currentUser?.name.split(' ').first ?? 'Student';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hi, $userName! 👋',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Main Campus Canteen • Open',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          // Profile Action
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Profile & Orders',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          // Cart Action with Badge
          Consumer<AppState>(
            builder: (context, appState, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: 'Shopping Cart',
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
          child: CustomScrollView(
            slivers: [
              // Promo Banner & Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Announcement Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.secondaryColor, Color(0xFF134E4A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt_rounded, color: Colors.amberAccent, size: 28),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Skip the Lecture Break Rush!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Order 15 mins ahead & pickup instantly at Counter #1.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Search Input
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          return TextField(
                            onChanged: appState.setSearchQuery,
                            decoration: InputDecoration(
                              hintText: 'Search Rice, Kottu, Tea, Snacks...',
                              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                              suffixIcon: appState.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 18),
                                      onPressed: () => appState.setSearchQuery(''),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      // Category Filters
                      _buildCategoryFilters(context),
                    ],
                  ),
                ),
              ),

              // Menu Items Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      final categoryTitle = appState.selectedCategory?.displayName ?? 'Today\'s Campus Menu';
                      final count = appState.filteredFoodItems.length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categoryTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '$count items available',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Responsive Food Grid / List
              Consumer<AppState>(
                builder: (context, appState, child) {
                  final items = appState.filteredFoodItems;

                  if (items.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 64, color: AppTheme.textMuted),
                            const SizedBox(height: 12),
                            const Text(
                              'No food items found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Try searching for something else or clear filters',
                              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                appState.setSearchQuery('');
                                appState.selectCategory(null);
                              },
                              child: const Text('Reset Filters'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final crossAxisCount = ResponsiveLayout.getGridColumnCount(context);

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: crossAxisCount == 1 ? 2.3 : (crossAxisCount == 2 ? 0.72 : 0.8),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return FoodCard(
                            item: item,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(item: item),
                                ),
                              );
                            },
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  );
                },
              ),

              // Bottom Spacer
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.cartTotalCount == 0) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            backgroundColor: AppTheme.primaryColor,
            elevation: 4,
            icon: const Icon(Icons.shopping_bag_rounded, color: Colors.white),
            label: Text(
              'View Cart (${appState.cartTotalCount}) • ${appState.formattedCartGrandTotal}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final allCount = appState.allFoodItems.length;
        final mealsCount = appState.allFoodItems.where((i) => i.category == FoodCategory.meals).length;
        final beveragesCount = appState.allFoodItems.where((i) => i.category == FoodCategory.beverages).length;
        final snacksCount = appState.allFoodItems.where((i) => i.category == FoodCategory.snacks).length;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CategoryChip(
                category: null,
                label: 'All Items',
                icon: Icons.grid_view_rounded,
                isSelected: appState.selectedCategory == null,
                count: allCount,
                onTap: () => appState.selectCategory(null),
              ),
              const SizedBox(width: 8),
              CategoryChip(
                category: FoodCategory.meals,
                label: FoodCategory.meals.displayName,
                icon: Icons.dinner_dining_rounded,
                isSelected: appState.selectedCategory == FoodCategory.meals,
                count: mealsCount,
                onTap: () => appState.selectCategory(FoodCategory.meals),
              ),
              const SizedBox(width: 8),
              CategoryChip(
                category: FoodCategory.beverages,
                label: FoodCategory.beverages.displayName,
                icon: Icons.emoji_food_beverage_rounded,
                isSelected: appState.selectedCategory == FoodCategory.beverages,
                count: beveragesCount,
                onTap: () => appState.selectCategory(FoodCategory.beverages),
              ),
              const SizedBox(width: 8),
              CategoryChip(
                category: FoodCategory.snacks,
                label: FoodCategory.snacks.displayName,
                icon: Icons.bakery_dining_rounded,
                isSelected: appState.selectedCategory == FoodCategory.snacks,
                count: snacksCount,
                onTap: () => appState.selectCategory(FoodCategory.snacks),
              ),
            ],
          ),
        );
      },
    );
  }
}
