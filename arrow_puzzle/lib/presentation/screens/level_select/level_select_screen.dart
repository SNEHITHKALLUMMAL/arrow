import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/levels/level_data.dart';
import '../../providers/providers.dart';

/// Level select screen with paginated grid.
class LevelSelectScreen extends ConsumerStatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  ConsumerState<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends ConsumerState<LevelSelectScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Start on the page containing the highest unlocked level
    final progress = ref.read(progressProvider);
    final startPage =
        (progress.highestUnlockedLevel - 1) ~/ LevelData.levelsPerPage;
    _pageController = PageController(initialPage: startPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final totalPages =
        (LevelData.totalLevels / LevelData.levelsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, _) {
                    double page = 0;
                    if (_pageController.hasClients && _pageController.page != null) {
                      page = _pageController.page!;
                    }
                    final isActive = (page.round() == index);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          // Level pages
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              itemBuilder: (context, pageIndex) {
                final startId = pageIndex * LevelData.levelsPerPage + 1;
                final endId =
                    (startId + LevelData.levelsPerPage - 1)
                        .clamp(1, LevelData.totalLevels);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: endId - startId + 1,
                    itemBuilder: (context, index) {
                      final levelId = startId + index;
                      final level = LevelData.getLevelById(levelId);
                      final isUnlocked = progress.isLevelUnlocked(levelId);
                      final isCompleted =
                          progress.completedLevels.contains(levelId);
                      final stars = progress.starsForLevel(levelId);

                      return _LevelTile(
                        levelId: levelId,
                        isUnlocked: isUnlocked,
                        isCompleted: isCompleted,
                        stars: stars,
                        onTap: () {
                          if (isUnlocked && level != null) {
                            Navigator.pushNamed(
                              context,
                              '/game',
                              arguments: level,
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class _LevelTile extends StatelessWidget {
  final int levelId;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;
  final VoidCallback onTap;

  const _LevelTile({
    required this.levelId,
    required this.isUnlocked,
    required this.isCompleted,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: !isUnlocked
              ? Colors.grey.withValues(alpha: 0.1)
              : isCompleted
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: !isUnlocked
                ? Colors.grey.withValues(alpha: 0.15)
                : isCompleted
                    ? AppColors.success.withValues(alpha: 0.3)
                    : AppColors.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isUnlocked)
              Icon(
                Icons.lock,
                size: 18,
                color: Colors.grey.withValues(alpha: 0.3),
              )
            else ...[
              Text(
                '$levelId',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isCompleted
                      ? AppColors.success
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (isCompleted && stars > 0) ...[
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Icon(
                      i < stars ? Icons.star : Icons.star_border,
                      size: 10,
                      color: i < stars
                          ? AppColors.star
                          : Colors.grey.withValues(alpha: 0.3),
                    );
                  }),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
