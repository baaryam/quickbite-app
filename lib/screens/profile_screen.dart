import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';
import 'order_tracking_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Student Profile'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final user = appState.currentUser;
          final orders = appState.orderHistory;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveLayout.getMaxContentWidth(context),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ResponsiveLayout(
                  mobile: _buildProfileMobile(context, appState, user, orders, dateFormat),
                  tablet: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildUserCard(context, appState, user)),
                      const SizedBox(width: 24),
                      Expanded(flex: 6, child: _buildOrderHistorySection(context, orders, dateFormat)),
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

  Widget _buildProfileMobile(
    BuildContext context,
    AppState appState,
    UserProfile? user,
    List<OrderModel> orders,
    DateFormat dateFormat,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildUserCard(context, appState, user),
        const SizedBox(height: 24),
        _buildOrderHistorySection(context, orders, dateFormat),
      ],
    );
  }

  Widget _buildUserCard(BuildContext context, AppState appState, UserProfile? user) {
    final isGuest = user?.isGuest ?? true;
    final userName = user?.name ?? 'Guest Student';
    final userEmail = user?.email ?? 'guest@campus.ac.lk';
    final studentId = user?.studentId ?? 'GST-0000';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // User Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isGuest
                      ? [Colors.blueGrey, Colors.grey]
                      : [AppTheme.primaryColor, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'G',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // User Name
            Text(
              userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // Email
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            // Guest or Registered Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isGuest ? AppTheme.primaryLight : AppTheme.secondaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isGuest ? 'GUEST ACCESS MODE' : 'VERIFIED STUDENT: $studentId',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isGuest ? AppTheme.primaryDark : AppTheme.secondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Divider(color: AppTheme.borderLight),
            const SizedBox(height: 14),

            // Account Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Orders', '${appState.orderHistory.length}'),
                Container(width: 1, height: 28, color: AppTheme.borderLight),
                _buildStatItem('Campus', 'Main'),
                Container(width: 1, height: 28, color: AppTheme.borderLight),
                _buildStatItem('Faculty', 'Computing'),
              ],
            ),
            const SizedBox(height: 20),

            // Sign out / Switch Account button
            OutlinedButton.icon(
              onPressed: () {
                appState.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              icon: const Icon(Icons.logout_rounded, size: 18, color: AppTheme.errorRed),
              label: const Text(
                'Sign Out / Switch Account',
                style: TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.errorRed, width: 1.2),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderHistorySection(BuildContext context, List<OrderModel> orders, DateFormat dateFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Order History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${orders.length} order(s)',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (orders.isEmpty)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(28.0),
              child: Center(
                child: Text('No previous orders found.', style: TextStyle(color: AppTheme.textSecondary)),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderHistoryCard(context, order, dateFormat);
            },
          ),
      ],
    );
  }

  Widget _buildOrderHistoryCard(BuildContext context, OrderModel order, DateFormat dateFormat) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderTrackingScreen(orderId: order.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long_rounded, size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        order.id,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(order.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _getStatusTextColor(order.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date/Time
              Text(
                dateFormat.format(order.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),

              // Items preview
              Text(
                order.items.map((i) => '${i.quantity}x ${i.foodItem.name}').join(', '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: AppTheme.borderLight),
              const SizedBox(height: 6),

              // Total & Track action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.formattedTotal,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'Track & Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.secondaryColor),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusBgColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return AppTheme.primaryLight;
      case OrderStatus.preparing:
        return Colors.amber.shade100;
      case OrderStatus.readyForPickup:
        return Colors.green.shade100;
      case OrderStatus.completed:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return AppTheme.primaryDark;
      case OrderStatus.preparing:
        return Colors.orange.shade900;
      case OrderStatus.readyForPickup:
        return AppTheme.successGreen;
      case OrderStatus.completed:
        return Colors.grey.shade700;
    }
  }
}
