import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLarge;

  const QuantityButton({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 40.0 : 32.0;
    final iconSize = isLarge ? 20.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: quantity <= 1 && !isLarge ? Icons.delete_outline_rounded : Icons.remove_rounded,
            color: quantity <= 1 && !isLarge ? AppTheme.errorRed : AppTheme.textPrimary,
            onPressed: onDecrement,
            size: size,
            iconSize: iconSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isLarge ? 16.0 : 10.0),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: isLarge ? 18 : 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add_rounded,
            color: AppTheme.primaryColor,
            onPressed: onIncrement,
            size: size,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double size,
    required double iconSize,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: iconSize,
          color: color,
        ),
      ),
    );
  }
}
