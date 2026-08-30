import '../../data/models/models.dart';

/// Pure game logic functions for the Arrow Puzzle game.
/// All functions are stateless and testable.
class GameLogic {
  /// Checks if an arrow can be removed.
  /// An arrow can be removed if every cell in the direction it points
  /// to is empty all the way to the edge of the board.
  static bool canRemoveArrow(
    List<List<Arrow?>> board,
    Arrow arrow,
  ) {
    final (rowDelta, colDelta) = arrow.direction.delta;
    int r = arrow.row + rowDelta;
    int c = arrow.col + colDelta;

    // Check all cells in the direction until we hit the board edge.
    while (r >= 0 && r < board.length && c >= 0 && c < board[0].length) {
      if (board[r][c] != null) {
        return false; // Blocked by another arrow.
      }
      r += rowDelta;
      c += colDelta;
    }

    return true; // Path is clear all the way to the edge.
  }

  /// Removes an arrow from the board and returns the updated board.
  /// Does NOT check if the move is valid — caller must check first.
  static List<List<Arrow?>> removeArrow(
    List<List<Arrow?>> board,
    Arrow arrow,
  ) {
    final newBoard = board.map((row) => List<Arrow?>.from(row)).toList();
    newBoard[arrow.row][arrow.col] = null;
    return newBoard;
  }

  /// Finds all arrows that can currently be removed.
  static List<Arrow> findRemovableArrows(List<List<Arrow?>> board) {
    final removable = <Arrow>[];
    for (final row in board) {
      for (final cell in row) {
        if (cell != null && canRemoveArrow(board, cell)) {
          removable.add(cell);
        }
      }
    }
    return removable;
  }

  /// Picks the best hint arrow from the currently removable ones.
  /// Strategy: prefer the arrow whose removal opens the most new paths.
  static Arrow? findHintArrow(List<List<Arrow?>> board) {
    final removable = findRemovableArrows(board);
    if (removable.isEmpty) return null;

    // Score each removable arrow by how many other arrows it frees up.
    Arrow bestArrow = removable.first;
    int bestScore = -1;

    for (final arrow in removable) {
      final boardAfterRemoval = removeArrow(board, arrow);
      final freedCount = findRemovableArrows(boardAfterRemoval).length;
      if (freedCount > bestScore) {
        bestScore = freedCount;
        bestArrow = arrow;
      }
    }

    return bestArrow;
  }

  /// Counts how many arrows remain on the board.
  static int countArrows(List<List<Arrow?>> board) {
    int count = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell != null) count++;
      }
    }
    return count;
  }

  /// Validates that a board has a solution (all arrows can eventually be removed).
  /// Uses a simple BFS approach.
  static bool hasSolution(List<List<Arrow?>> board) {
    // Work on a copy
    var currentBoard = board.map((row) => List<Arrow?>.from(row)).toList();

    while (true) {
      final removable = findRemovableArrows(currentBoard);
      if (removable.isEmpty) break;
      // Remove the first available arrow (we just need to verify solvability)
      currentBoard = removeArrow(currentBoard, removable.first);
    }

    return countArrows(currentBoard) == 0;
  }

  /// Validates that a level's initial board has a solution.
  static bool validateLevel(Level level) {
    final board = level.createBoard();
    return hasSolution(board);
  }
}
