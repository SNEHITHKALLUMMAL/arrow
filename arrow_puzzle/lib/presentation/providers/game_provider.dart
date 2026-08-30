import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../../core/utils/game_logic.dart';

/// Notifier that controls the active game session.
class GameController extends StateNotifier<LevelState?> {
  GameController() : super(null);

  /// Starts a new level.
  void startLevel(Level level, {bool isDailyChallenge = false}) {
    final board = level.createBoard();
    final arrowCount = GameLogic.countArrows(board);

    state = LevelState(
      levelId: level.id,
      board: board,
      rows: level.rows,
      cols: level.cols,
      lives: level.initialLives,
      maxLives: level.initialLives,
      arrowsRemaining: arrowCount,
      phase: GamePhase.ready,
      isDailyChallenge: isDailyChallenge,
    );
  }

  /// Attempts to tap an arrow at the given position.
  /// Returns: 'valid', 'invalid', or 'no_arrow'.
  String tapArrow(int row, int col) {
    if (state == null || state!.phase != GamePhase.ready) return 'no_arrow';

    final arrow = state!.board[row][col];
    if (arrow == null) return 'no_arrow';

    if (GameLogic.canRemoveArrow(state!.board, arrow)) {
      // Valid move — start removal animation.
      state = state!.copyWith(
        animatingArrow: arrow,
        phase: GamePhase.animatingRemoval,
        clearHintArrow: true,
        moveCount: state!.moveCount + 1,
      );
      return 'valid';
    } else {
      // Invalid move — lose a life.
      final newLives = state!.lives - 1;
      if (newLives <= 0) {
        state = state!.copyWith(
          lives: 0,
          phase: GamePhase.lost,
          animatingArrow: arrow,
        );
      } else {
        state = state!.copyWith(
          lives: newLives,
          animatingArrow: arrow,
          failReason: 'Blocked!',
        );
      }
      return 'invalid';
    }
  }

  /// Completes the removal animation — removes arrow from board.
  void completeRemoval() {
    if (state == null) return;
    if (state!.phase == GamePhase.lost) {
      // After fail animation, reset to ready
      state = state!.copyWith(
        phase: GamePhase.ready,
        clearAnimatingArrow: true,
        clearFailReason: true,
      );
      return;
    }

    final arrow = state!.animatingArrow;
    if (arrow == null) return;

    final newBoard = GameLogic.removeArrow(state!.board, arrow);
    final remaining = GameLogic.countArrows(newBoard);

    if (remaining == 0) {
      state = state!.copyWith(
        board: newBoard,
        arrowsRemaining: 0,
        phase: GamePhase.won,
        clearAnimatingArrow: true,
      );
    } else {
      state = state!.copyWith(
        board: newBoard,
        arrowsRemaining: remaining,
        phase: GamePhase.ready,
        clearAnimatingArrow: true,
      );
    }
  }

  /// Uses a hint — shows which arrow to tap next.
  bool useHint() {
    if (state == null || state!.phase != GamePhase.ready) return false;

    final hintArrow = GameLogic.findHintArrow(state!.board);
    if (hintArrow == null) return false;

    state = state!.copyWith(hintArrow: hintArrow);
    return true;
  }

  /// Pauses the game.
  void pause() {
    if (state == null) return;
    state = state!.copyWith(phase: GamePhase.paused);
  }

  /// Resumes the game.
  void resume() {
    if (state == null || state!.phase != GamePhase.paused) return;
    state = state!.copyWith(phase: GamePhase.ready);
  }

  /// Restarts the current level.
  void restart(Level level, {bool isDailyChallenge = false}) {
    startLevel(level, isDailyChallenge: isDailyChallenge);
  }

  /// Returns to home (clears state).
  void exitGame() {
    state = null;
  }

  /// Clears the fail reason display.
  void clearFailReason() {
    if (state == null) return;
    state = state!.copyWith(clearFailReason: true);
  }
}

/// Provider for the game controller.
final gameProvider = StateNotifierProvider<GameController, LevelState?>(
  (ref) => GameController(),
);

/// Derived provider: is the game currently won?
final isGameWonProvider = Provider<bool>((ref) {
  final state = ref.watch(gameProvider);
  return state?.phase == GamePhase.won;
});

/// Derived provider: is the game currently lost?
final isGameLostProvider = Provider<bool>((ref) {
  final state = ref.watch(gameProvider);
  return state?.phase == GamePhase.lost;
});
