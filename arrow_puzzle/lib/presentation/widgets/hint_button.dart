import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Hint button with a badge showing remaining hints.
class HintButton extends StatelessWidget {
  final int hintsRemaining;
  final VoidCallback onPressed;

  const HintButton({
    super.key,
    required this.hintsRemaining,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: hintsRemaining > 0 ? onPressed : null,
          icon: Icon(
            Icons.lightbulb_outline,
            color: hintsRemaining > 0
                ? AppColors.hint
                : Colors.grey.withValues(alpha: 0.4),
            size: 28,
          ),
          tooltip: 'Hint ($hintsRemaining remaining)',
        ),
        if (hintsRemaining > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.hint,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.hint.withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                '$hintsRemaining',
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
  }
}
