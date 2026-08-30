import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// Overlay shown when a level is completed.
class LevelCompleteOverlay extends StatelessWidget {
  final int levelId;
  final int stars;
  final int moveCount;
  final VoidCallback onNext;
  final VoidCallback onReplay;
  final VoidCallback onHome;

  const LevelCompleteOverlay({
    super.key,
    required this.levelId,
    required this.stars,
    required this.moveCount,
    required this.onNext,
    required this.onReplay,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Level Complete!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.success,
                  ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3),

            const SizedBox(height: 16),

            // Level info
            Text(
              'Level $levelId • $moveCount moves',
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final earned = index < stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    earned ? Icons.star : Icons.star_border,
                    color: earned ? AppColors.star : Colors.grey.withValues(alpha: 0.3),
                    size: 48,
                  )
                      .animate(delay: Duration(milliseconds: 300 + index * 200))
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        curve: Curves.elasticOut,
                      ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Home button
                _ActionButton(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: onHome,
                ),
                const SizedBox(width: 16),
                // Replay button
                _ActionButton(
                  icon: Icons.replay,
                  label: 'Replay',
                  onTap: onReplay,
                ),
                const SizedBox(width: 16),
                // Next button
                _ActionButton(
                  icon: Icons.arrow_forward,
                  label: 'Next',
                  onTap: onNext,
                  isPrimary: true,
                ),
              ],
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.primary : Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
