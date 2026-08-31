import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/levels/level_data.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

/// The main game screen where gameplay happens.
class GameScreen extends ConsumerStatefulWidget {
  final Level level;
  final bool isDailyChallenge;

  const GameScreen({
    super.key,
    required this.level,
    this.isDailyChallenge = false,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late Level _currentLevel;
  bool _progressSaved = false;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.level;
    _progressSaved = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).startLevel(
            _currentLevel,
            isDailyChallenge: widget.isDailyChallenge,
          );
    });
  }

  @override
  void dispose() {
    ref.read(gameProvider.notifier).exitGame();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _onNextLevel() {
    final nextId = _currentLevel.id + 1;
    final nextLevel = LevelData.getLevelById(nextId);
    if (nextLevel != null) {
      setState(() {
        _currentLevel = nextLevel;
        _progressSaved = false;
      });
      ref.read(gameProvider.notifier).startLevel(nextLevel);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    }
  }

  void _onReplay() {
    setState(() => _progressSaved = false);
    ref.read(gameProvider.notifier).restart(_currentLevel);
  }

  void _onRetry() {
    setState(() => _progressSaved = false);
    ref.read(gameProvider.notifier).restart(_currentLevel);
  }

  void _onHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  void _onHint() {
    final game = ref.read(gameProvider.notifier);
    final hasHints = ref.read(progressProvider).hasHints;
    if (!hasHints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hints remaining!'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    final used = game.useHint();
    if (used) {
      ref.read(progressProvider.notifier).useHint();
    }
  }

  void _onPause() {
    ref.read(gameProvider.notifier).pause();
    _showPauseMenu();
  }

  void _showPauseMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Paused',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _PauseButton(
              icon: Icons.play_arrow_rounded,
              label: 'Resume',
              onTap: () {
                Navigator.pop(ctx);
                ref.read(gameProvider.notifier).resume();
              },
            ),
            const SizedBox(height: 12),
            _PauseButton(
              icon: Icons.replay,
              label: 'Restart Level',
              onTap: () {
                Navigator.pop(ctx);
                _onReplay();
              },
            ),
            const SizedBox(height: 12),
            _PauseButton(
              icon: Icons.home,
              label: 'Home',
              onTap: () {
                Navigator.pop(ctx);
                _onHome();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ).then((_) {
      final state = ref.read(gameProvider);
      if (state?.phase == GamePhase.paused) {
        ref.read(gameProvider.notifier).resume();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    final progress = ref.watch(progressProvider);

    // Save progress on win (once)
    if (state?.phase == GamePhase.won && !_progressSaved) {
      _progressSaved = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(progressProvider.notifier).completeLevel(
              _currentLevel.id,
              state!.starRating,
            );
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main game content
          SafeArea(
            child: state == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _GameTopBar(
                        levelId: _currentLevel.id,
                        lives: state.lives,
                        maxLives: state.maxLives,
                        hintsRemaining: progress.hintsRemaining,
                        onHint: _onHint,
                        onPause: _onPause,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.grid_view,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${state.arrowsRemaining} arrows remaining',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: GameBoard(levelState: state),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
          ),

          // Win overlay
          if (state?.phase == GamePhase.won)
            LevelCompleteOverlay(
              levelId: _currentLevel.id,
              stars: state!.starRating,
              moveCount: state.moveCount,
              onNext: _onNextLevel,
              onReplay: _onReplay,
              onHome: _onHome,
            ),

          // Game Over overlay
          if (state?.phase == GamePhase.lost && state?.lives == 0)
            GameOverOverlay(
              levelId: _currentLevel.id,
              onRetry: _onRetry,
              onHome: _onHome,
              onWatchAd: () {
                // Placeholder: award an extra life
                // In production, this would show a rewarded ad
              },
            ),
        ],
      ),
    );
  }
}

class _GameTopBar extends StatelessWidget {
  final int levelId;
  final int lives;
  final int maxLives;
  final int hintsRemaining;
  final VoidCallback onHint;
  final VoidCallback onPause;

  const _GameTopBar({
    required this.levelId,
    required this.lives,
    required this.maxLives,
    required this.hintsRemaining,
    required this.onHint,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onPause,
            icon: Icon(
              Icons.pause_circle_outline,
              color: Theme.of(context).colorScheme.onSurface,
              size: 32,
            ),
          ),
          const Spacer(),
          Text(
            'Level $levelId',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          LivesBar(lives: lives, maxLives: maxLives),
          const SizedBox(width: 8),
          HintButton(
            hintsRemaining: hintsRemaining,
            onPressed: onHint,
          ),
        ],
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PauseButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTap,
    );
  }
}
