import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Handles persistence using shared_preferences.
class ProgressStorage {
  static const String _completedLevelsKey = 'completed_levels';
  static const String _starsPerLevelKey = 'stars_per_level';
  static const String _highestUnlockedKey = 'highest_unlocked';
  static const String _dailyStreakKey = 'daily_streak';
  static const String _lastDailyDateKey = 'last_daily_date';
  static const String _hintsRemainingKey = 'hints_remaining';
  static const String _totalHintsUsedKey = 'total_hints_used';
  static const String _totalLevelsCompletedKey = 'total_levels_completed';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _darkModeEnabledKey = 'dark_mode_enabled';

  /// Loads the player's progress from disk.
  static Future<PlayerProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final completedList = prefs.getStringList(_completedLevelsKey) ?? [];
    final completedLevels = completedList.map(int.parse).toSet();

    final starsJson = prefs.getString(_starsPerLevelKey) ?? '{}';
    final starsMap = Map<int, int>.from(
      (jsonDecode(starsJson) as Map).map((k, v) => MapEntry(int.parse(k.toString()), v as int)),
    );

    return PlayerProgress(
      completedLevels: completedLevels,
      starsPerLevel: starsMap,
      highestUnlockedLevel: prefs.getInt(_highestUnlockedKey) ?? 1,
      dailyStreak: prefs.getInt(_dailyStreakKey) ?? 0,
      lastDailyDate: prefs.getString(_lastDailyDateKey),
      hintsRemaining: prefs.getInt(_hintsRemainingKey) ?? 10,
      totalHintsUsed: prefs.getInt(_totalHintsUsedKey) ?? 0,
      totalLevelsCompleted: prefs.getInt(_totalLevelsCompletedKey) ?? 0,
      hasSeenOnboarding: prefs.getBool(_hasSeenOnboardingKey) ?? false,
      soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
      musicEnabled: prefs.getBool(_musicEnabledKey) ?? true,
      vibrationEnabled: prefs.getBool(_vibrationEnabledKey) ?? true,
      darkModeEnabled: prefs.getBool(_darkModeEnabledKey) ?? false,
    );
  }

  /// Saves the player's progress to disk.
  static Future<void> saveProgress(PlayerProgress progress) async {
    final prefs = await SharedPreferences.getInstance();

    final completedList = progress.completedLevels.map((id) => id.toString()).toList();
    await prefs.setStringList(_completedLevelsKey, completedList);

    final starsJson = jsonEncode(
      progress.starsPerLevel.map((k, v) => MapEntry(k.toString(), v)),
    );
    await prefs.setString(_starsPerLevelKey, starsJson);

    await prefs.setInt(_highestUnlockedKey, progress.highestUnlockedLevel);
    await prefs.setInt(_dailyStreakKey, progress.dailyStreak);
    if (progress.lastDailyDate != null) {
      await prefs.setString(_lastDailyDateKey, progress.lastDailyDate!);
    }
    await prefs.setInt(_hintsRemainingKey, progress.hintsRemaining);
    await prefs.setInt(_totalHintsUsedKey, progress.totalHintsUsed);
    await prefs.setInt(_totalLevelsCompletedKey, progress.totalLevelsCompleted);
    await prefs.setBool(_hasSeenOnboardingKey, progress.hasSeenOnboarding);
    await prefs.setBool(_soundEnabledKey, progress.soundEnabled);
    await prefs.setBool(_musicEnabledKey, progress.musicEnabled);
    await prefs.setBool(_vibrationEnabledKey, progress.vibrationEnabled);
    await prefs.setBool(_darkModeEnabledKey, progress.darkModeEnabled);
  }

  /// Resets all progress.
  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
