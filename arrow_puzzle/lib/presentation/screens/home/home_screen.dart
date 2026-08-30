import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../widgets/daily_challenge_card.dart';

/// Home screen with play button, daily challenge, and settings.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    // Check if daily challenge is completed today
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final isDailyCompleted = progress.lastDailyDate == todayStr;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // App icon and title
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
              ).animate().scale(
                    begin: const Offset(0, 0),
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 16),

              Text(
                'Arrow Puzzle',
                style: Theme.of(context).textTheme.headlineLarge,
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 40),

              // Play button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/level_select');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Play',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

              const SizedBox(height: 24),

              // Daily Challenge card
              DailyChallengeCard(
                isCompletedToday: isDailyCompleted,
                streak: progress.dailyStreak,
                onTap: () {
                  Navigator.pushNamed(context, '/daily_challenge');
                },
              ),

              const SizedBox(height: 24),

              // Stats row
              Row(
                children: [
                  _StatCard(
                    icon: Icons.check_circle_outline,
                    label: 'Completed',
                    value: '${progress.totalLevelsCompleted}',
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.star_outline,
                    label: 'Stars',
                    value: _totalStars(progress.starsPerLevel),
                    color: AppColors.star,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.lightbulb_outline,
                    label: 'Hints',
                    value: '${progress.hintsRemaining}',
                    color: AppColors.hint,
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 24),

              // Settings button
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: Icon(
                  Icons.settings,
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                label: Text(
                  'Settings',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _totalStars(Map<int, int> stars) {
    int total = 0;
    for (final stars in stars.values) {
      total += stars;
    }
    return '$total';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
