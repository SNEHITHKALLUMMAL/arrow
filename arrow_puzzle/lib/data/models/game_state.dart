import 'arrow.dart';

/// Represents the current phase of gameplay.
enum GamePhase {
  ready,
  animatingRemoval,
  won,
  lost,
  paused,
}

/// The complete state of the current game session.
class LevelState {
  final int levelId;
  final List<List<Arrow?>> board;
  final int rows;
  final int cols;
  final int lives;
  final int maxLives;
  final int arrowsRemaining;
  final GamePhase phase;
  final Arrow? animatingArrow;
  final Arrow? hintArrow;
  final int hintsUsedInLevel;
  final int moveCount;
  final bool isDailyChallenge;
  final String? failReason;

  const LevelState({
    required this.levelId,
    required this.board,
    required this.rows,
    required this.cols,
    required this.lives,
    required this.maxLives,
    required this.arrowsRemaining,
    required this.phase,
    this.animatingArrow,
    this.hintArrow,
    this.hintsUsedInLevel = 0,
    this.moveCount = 0,
    this.isDailyChallenge = false,
    this.failReason,
  });

  /// Whether the game is actively playable (not animating, not over).
  bool get isPlaying => phase == GamePhase.ready;

  /// Whether all arrows have been removed.
  bool get isComplete => arrowsRemaining == 0;

  /// Star rating based on moves and lives remaining.
  /// 3 stars: no wrong moves, 2 stars: 1-2 wrong, 1 star: rest
  int get starRating {
    final wrongMoves = maxLives - lives;
    if (wrongMoves == 0) return 3;
    if (wrongMoves <= 2) return 2;
    return 1;
  }

  LevelState copyWith({
    List<List<Arrow?>>? board,
    int? lives,
    int? arrowsRemaining,
    GamePhase? phase,
    Arrow? animatingArrow,
    Arrow? hintArrow,
    int? hintsUsedInLevel,
    int? moveCount,
    bool? clearAnimatingArrow = false,
    bool? clearHintArrow = false,
    bool? clearFailReason = false,
    String? failReason,
  }) {
    return LevelState(
      levelId: levelId,
      board: board ?? this.board,
      rows: rows,
      cols: cols,
      lives: lives ?? this.lives,
      maxLives: maxLives,
      arrowsRemaining: arrowsRemaining ?? this.arrowsRemaining,
      phase: phase ?? this.phase,
      animatingArrow: (clearAnimatingArrow == true)
          ? null
          : (animatingArrow ?? this.animatingArrow),
      hintArrow: (clearHintArrow == true)
          ? null
          : (hintArrow ?? this.hintArrow),
      hintsUsedInLevel: hintsUsedInLevel ?? this.hintsUsedInLevel,
      moveCount: moveCount ?? this.moveCount,
      isDailyChallenge: isDailyChallenge,
      failReason: (clearFailReason == true)
          ? null
          : (failReason ?? this.failReason),
    );
  }
}
