/// Tracks player progress across the game.
class PlayerProgress {
  /// Set of completed level IDs.
  final Set<int> completedLevels;

  /// Map of level ID to star rating (0-3).
  final Map<int, int> starsPerLevel;

  /// Highest unlocked level number.
  final int highestUnlockedLevel;

  /// Daily challenge streak count.
  final int dailyStreak;

  /// Last date a daily challenge was completed (yyyy-MM-dd string).
  final String? lastDailyDate;

  /// Number of hints remaining.
  final int hintsRemaining;

  /// Total number of hints used (lifetime).
  final int totalHintsUsed;

  /// Total levels completed (lifetime).
  final int totalLevelsCompleted;

  /// Whether onboarding has been shown.
  final bool hasSeenOnboarding;

  /// Sound enabled.
  final bool soundEnabled;

  /// Music enabled.
  final bool musicEnabled;

  /// Vibration enabled.
  final bool vibrationEnabled;

  /// Dark mode enabled.
  final bool darkModeEnabled;

  const PlayerProgress({
    this.completedLevels = const {},
    this.starsPerLevel = const {},
    this.highestUnlockedLevel = 1,
    this.dailyStreak = 0,
    this.lastDailyDate,
    this.hintsRemaining = 10,
    this.totalHintsUsed = 0,
    this.totalLevelsCompleted = 0,
    this.hasSeenOnboarding = false,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.vibrationEnabled = true,
    this.darkModeEnabled = false,
  });

  /// Returns stars for a given level (0 if not completed).
  int starsForLevel(int levelId) => starsPerLevel[levelId] ?? 0;

  /// Whether a level is unlocked (the player can play it).
  bool isLevelUnlocked(int levelId) => levelId <= highestUnlockedLevel;

  /// Whether the player has hints left.
  bool get hasHints => hintsRemaining > 0;

  PlayerProgress copyWith({
    Set<int>? completedLevels,
    Map<int, int>? starsPerLevel,
    int? highestUnlockedLevel,
    int? dailyStreak,
    String? lastDailyDate,
    int? hintsRemaining,
    int? totalHintsUsed,
    int? totalLevelsCompleted,
    bool? hasSeenOnboarding,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
    bool? darkModeEnabled,
  }) {
    return PlayerProgress(
      completedLevels: completedLevels ?? this.completedLevels,
      starsPerLevel: starsPerLevel ?? this.starsPerLevel,
      highestUnlockedLevel:
          highestUnlockedLevel ?? this.highestUnlockedLevel,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastDailyDate: lastDailyDate ?? this.lastDailyDate,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      totalHintsUsed: totalHintsUsed ?? this.totalHintsUsed,
      totalLevelsCompleted:
          totalLevelsCompleted ?? this.totalLevelsCompleted,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  /// Marks a level as completed with the given star rating.
  PlayerProgress completeLevel(int levelId, int stars) {
    final newCompleted = Set<int>.from(completedLevels)..add(levelId);
    final newStars = Map<int, int>.from(starsPerLevel);
    final currentStars = newStars[levelId] ?? 0;
    if (stars > currentStars) {
      newStars[levelId] = stars;
    }
    return copyWith(
      completedLevels: newCompleted,
      starsPerLevel: newStars,
      highestUnlockedLevel:
          levelId >= highestUnlockedLevel ? levelId + 1 : highestUnlockedLevel,
      totalLevelsCompleted: totalLevelsCompleted + 1,
    );
  }

  /// Uses a hint (decrements hint count).
  PlayerProgress useHint() {
    return copyWith(
      hintsRemaining: hintsRemaining - 1,
      totalHintsUsed: totalHintsUsed + 1,
    );
  }

  /// Adds hints back.
  PlayerProgress addHints(int count) {
    return copyWith(hintsRemaining: hintsRemaining + count);
  }
}
