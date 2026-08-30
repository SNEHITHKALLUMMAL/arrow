import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/progress_storage.dart';
import '../../data/models/models.dart';

/// Provider for the player's progress, loaded from storage.
final progressProvider =
    StateNotifierProvider<ProgressController, PlayerProgress>((ref) {
  return ProgressController();
});

/// Manages player progress with persistence.
class ProgressController extends StateNotifier<PlayerProgress> {
  ProgressController() : super(const PlayerProgress()) {
    _load();
  }

  Future<void> _load() async {
    state = await ProgressStorage.loadProgress();
  }

  Future<void> save() async {
    await ProgressStorage.saveProgress(state);
  }

  /// Marks a level as completed with star rating.
  Future<void> completeLevel(int levelId, int stars) async {
    state = state.completeLevel(levelId, stars);
    await save();
  }

  /// Uses a hint.
  Future<void> useHint() async {
    state = state.useHint();
    await save();
  }

  /// Adds hints.
  Future<void> addHints(int count) async {
    state = state.addHints(count);
    await save();
  }

  /// Completes daily challenge.
  Future<void> completeDailyChallenge(String date) async {
    int newStreak = state.dailyStreak;
    if (state.lastDailyDate != date) {
      // Simple streak: increment if completed today or yesterday
      newStreak = state.dailyStreak + 1;
    }
    state = state.copyWith(
      dailyStreak: newStreak,
      lastDailyDate: date,
    );
    await save();
  }

  /// Marks onboarding as seen.
  Future<void> completeOnboarding() async {
    state = state.copyWith(hasSeenOnboarding: true);
    await save();
  }

  /// Toggles sound.
  Future<void> toggleSound() async {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
    await save();
  }

  /// Toggles music.
  Future<void> toggleMusic() async {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
    await save();
  }

  /// Toggles vibration.
  Future<void> toggleVibration() async {
    state = state.copyWith(vibrationEnabled: !state.vibrationEnabled);
    await save();
  }

  /// Toggles dark mode.
  Future<void> toggleDarkMode() async {
    state = state.copyWith(darkModeEnabled: !state.darkModeEnabled);
    await save();
  }

  /// Resets all progress.
  Future<void> resetAll() async {
    await ProgressStorage.resetProgress();
    state = const PlayerProgress();
  }
}
