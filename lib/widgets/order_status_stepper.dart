import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrderStatusStepper extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderStatusStepper({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      _StepInfo(
        title: 'Placed',
        subtitle: 'Order received & queued at canteen',
        icon: Icons.receipt_long_rounded,
        status: OrderStatus.placed,
      ),
      _StepInfo(
        title: 'Preparing',
        subtitle: 'Canteen chef is freshly cooking your meal',
        icon: Icons.soup_kitchen_rounded,
        status: OrderStatus.preparing,
      ),
      _StepInfo(
        title: 'Ready for pickup',
        subtitle: 'Food is boxed & ready at Counter #1',
        icon: Icons.notifications_active_rounded,
        status: OrderStatus.readyForPickup,
      ),
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isDone = currentStatus.stepIndex > index;
        final isActive = currentStatus.stepIndex == index;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppTheme.successGreen
                        : isActive
                            ? AppTheme.primaryColor
                            : Colors.white,
                    border: Border.all(
                      color: isDone
                          ? AppTheme.successGreen
                          : isActive
                              ? AppTheme.primaryColor
                              : AppTheme.borderLight,
                      width: 2.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Icon(
                      isDone
                          ? Icons.check_rounded
                          : step.icon,
                      size: 20,
                      color: isDone || isActive
                          ? Colors.white
                          : AppTheme.textMuted,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 3,
                    height: 50,
                    color: isDone ? AppTheme.successGreen : AppTheme.borderLight,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Step text details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? AppTheme.primaryDark
                                : isDone
                                    ? AppTheme.textPrimary
                                    : AppTheme.textMuted,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StepInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final OrderStatus status;

  _StepInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.status,
  });
}
