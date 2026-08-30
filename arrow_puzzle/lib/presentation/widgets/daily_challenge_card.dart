import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// Card widget for the daily challenge on the home screen.
class DailyChallengeCard extends StatelessWidget {
  final bool isCompletedToday;
  final int streak;
  final VoidCallback onTap;

  const DailyChallengeCard({
    super.key,
    this.isCompletedToday = false,
    this.streak = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCompletedToday
                ? [
                    AppColors.success.withValues(alpha: 0.3),
                    AppColors.success.withValues(alpha: 0.1),
                  ]
                : [
                    AppColors.primary.withValues(alpha: 0.3),
                    const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompletedToday
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isCompletedToday
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isCompletedToday
                    ? Icons.check_circle_outline
                    : Icons.calendar_today,
                color:
                    isCompletedToday ? AppColors.success : AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Challenge',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompletedToday
                        ? 'Completed! ✓'
                        : streak > 0
                            ? '🔥 $streak day streak'
                            : 'New challenge available',
                    style: TextStyle(
                      fontSize: 13,
                      color: isCompletedToday
                          ? AppColors.success
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05);
  }
}
