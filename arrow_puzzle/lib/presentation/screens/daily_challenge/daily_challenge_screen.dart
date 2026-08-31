import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/levels/level_data.dart';
import '../../providers/providers.dart';

/// Daily challenge screen with calendar view and level access.
class DailyChallengeScreen extends ConsumerWidget {
  const DailyChallengeScreen({super.key});

  /// Generates a deterministic level for a given date.
  static Level getDailyLevel(DateTime date) {
    // Use date as seed for level selection
    final seed =
        date.year * 10000 + date.month * 100 + date.day;
    final levelIndex = seed % LevelData.totalLevels;
    return LevelData.allLevels[levelIndex];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final isCompletedToday = progress.lastDailyDate == todayStr;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenge'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Streak info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '🔥',
                    style: const TextStyle(fontSize: 48),
                  ).animate().scale(
                        begin: const Offset(0, 0),
                        curve: Curves.elasticOut,
                      ),
                  const SizedBox(height: 12),
                  Text(
                    '${progress.dailyStreak} Day Streak',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete a challenge every day\nto keep your streak going!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Today's challenge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCompletedToday
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompletedToday
                      ? AppColors.success.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d').format(now),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  if (isCompletedToday) ...[
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completed! ✓',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final dailyLevel = getDailyLevel(now);
                          Navigator.pushNamed(
                            context,
                            '/game',
                            arguments: dailyLevel,
                          );
                        },
                        child: const Text('Play Today\'s Challenge'),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Past days calendar (last 7 days)
            Text(
              'This Week',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final date = now.subtract(Duration(days: 6 - index));
                final dateStr =
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final isCompleted = progress.lastDailyDate == dateStr;
                final isToday = index == 6;
                final dayLabel = DateFormat('E').format(date);

                return Column(
                  children: [
                    Text(
                      dayLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.success
                            : isToday
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.success
                              : isToday
                                  ? AppColors.primary
                                  : Colors.grey.withValues(alpha: 0.2),
                          width: isToday ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isToday
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isToday
                                      ? AppColors.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
