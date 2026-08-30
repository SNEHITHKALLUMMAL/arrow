import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/models.dart';
import '../../core/constants/app_colors.dart';

/// A single arrow tile on the game board.
/// Handles tap detection, rendering, and removal animation.
class ArrowTile extends StatelessWidget {
  final Arrow arrow;
  final VoidCallback onTap;
  final bool isAnimating;
  final bool isHinted;
  final bool isFailed;
  final double cellSize;

  const ArrowTile({
    super.key,
    required this.arrow,
    required this.onTap,
    required this.cellSize,
    this.isAnimating = false,
    this.isHinted = false,
    this.isFailed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.arrowColor(arrow.direction.index);
    final iconSize = cellSize * 0.55;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.all(cellSize * 0.08),
        decoration: BoxDecoration(
          color: isFailed
              ? AppColors.error.withValues(alpha: 0.3)
              : color.withValues(alpha: isHinted ? 0.3 : 0.15),
          borderRadius: BorderRadius.circular(cellSize * 0.18),
          border: Border.all(
            color: isHinted
                ? AppColors.hint
                : isFailed
                    ? AppColors.error
                    : color.withValues(alpha: 0.4),
            width: isHinted ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isHinted ? 0.5 : 0.2),
              blurRadius: isHinted ? 12 : 4,
              spreadRadius: isHinted ? 2 : 0,
            ),
          ],
        ),
        child: Center(
          child: Transform.rotate(
            angle: arrow.direction.angle,
            child: Icon(
              Icons.arrow_upward_rounded,
              size: iconSize,
              color: color,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
