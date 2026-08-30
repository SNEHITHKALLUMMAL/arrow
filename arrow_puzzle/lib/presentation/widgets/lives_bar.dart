import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Displays the player's remaining lives as heart icons.
class LivesBar extends StatelessWidget {
  final int lives;
  final int maxLives;

  const LivesBar({
    super.key,
    required this.lives,
    required this.maxLives,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (index) {
        final isFilled = index < lives;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isFilled ? Icons.favorite : Icons.favorite_border,
              key: ValueKey('$index-${isFilled ? 'filled' : 'empty'}'),
              color: isFilled ? AppColors.life : Colors.grey.withValues(alpha: 0.3),
              size: 28,
            ),
          ),
        );
      }),
    );
  }
}
