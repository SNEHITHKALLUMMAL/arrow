import 'package:flutter_test/flutter_test.dart';
import 'package:arrow_puzzle/data/models/models.dart';
import 'package:arrow_puzzle/core/utils/game_logic.dart';

void main() {
  group('GameLogic.canRemoveArrow', () {
    test('arrow pointing up with clear path is removable', () {
      final board = [
        [null, null, null],
        [null, Arrow(row: 1, col: 1, direction: Direction.up, id: 'a1'), null],
        [null, null, null],
      ];
      expect(GameLogic.canRemoveArrow(board, board[1][1]!), isTrue);
    });

    test('arrow pointing up blocked by another arrow', () {
      final board = [
        [Arrow(row: 0, col: 1, direction: Direction.right, id: 'a2'), null, null],
        [null, Arrow(row: 1, col: 1, direction: Direction.up, id: 'a1'), null],
        [null, null, null],
      ];
      expect(GameLogic.canRemoveArrow(board, board[1][1]!), isFalse);
    });

    test('arrow pointing right with clear path is removable', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.right, id: 'a1'), null, null],
      ];
      expect(GameLogic.canRemoveArrow(board, board[0][0]!), isTrue);
    });

    test('arrow pointing right blocked', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.right, id: 'a1'), Arrow(row: 0, col: 1, direction: Direction.up, id: 'a2'), null],
      ];
      expect(GameLogic.canRemoveArrow(board, board[0][0]!), isFalse);
    });

    test('arrow at edge pointing outward is always removable', () {
      // Arrow at (0,0) pointing up - path is empty (outside board)
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.up, id: 'a1'), null, null],
        [null, null, null],
        [null, null, null],
      ];
      expect(GameLogic.canRemoveArrow(board, board[0][0]!), isTrue);
    });

    test('arrow pointing down with clear path is removable', () {
      final board = [
        [null, null, null],
        [null, Arrow(row: 1, col: 1, direction: Direction.down, id: 'a1'), null],
        [null, null, null],
      ];
      expect(GameLogic.canRemoveArrow(board, board[1][1]!), isTrue);
    });

    test('arrow pointing left with clear path is removable', () {
      final board = [
        [null, null, Arrow(row: 0, col: 2, direction: Direction.left, id: 'a1')],
      ];
      expect(GameLogic.canRemoveArrow(board, board[0][2]!), isTrue);
    });
  });

  group('GameLogic.removeArrow', () {
    test('removes arrow from board', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.up, id: 'a1'), null, null],
        [null, null, null],
      ];
      final newBoard = GameLogic.removeArrow(board, board[0][0]!);
      expect(newBoard[0][0], isNull);
      // Original board should not be modified
      expect(board[0][0], isNotNull);
    });
  });

  group('GameLogic.findRemovableArrows', () {
    test('finds all removable arrows', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.up, id: 'a1'), null, null],
        [null, Arrow(row: 1, col: 1, direction: Direction.down, id: 'a2'), null],
        [null, null, Arrow(row: 2, col: 2, direction: Direction.right, id: 'a3')],
      ];
      final removable = GameLogic.findRemovableArrows(board);
      expect(removable.length, 3);
    });

    test('returns empty when no arrows are removable', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.right, id: 'a1'), Arrow(row: 0, col: 1, direction: Direction.left, id: 'a2'), null],
      ];
      // a1 points right, blocked by a2. a2 points left, blocked by a1.
      // Both are on the edge, so they can actually be removed.
      // Let me fix: a1 points right, a2 at (0,1). Path is (0,1) which has a2. So blocked.
      // a2 points left, path is (0,0) which has a1. So blocked.
      // Wait, but the path from a1 going right: (0,1) has a2. Blocked.
      // Path from a2 going left: (0,0) has a1. Blocked.
      // So neither can be removed.
      final removable = GameLogic.findRemovableArrows(board);
      expect(removable.length, 0);
    });
  });

  group('GameLogic.countArrows', () {
    test('counts arrows correctly', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.up, id: 'a1'), null, null],
        [null, Arrow(row: 1, col: 1, direction: Direction.down, id: 'a2'), null],
        [null, null, null],
      ];
      expect(GameLogic.countArrows(board), 2);
    });

    test('returns 0 for empty board', () {
      final board = [
        [null, null, null],
        [null, null, null],
      ];
      expect(GameLogic.countArrows(board), 0);
    });
  });

  group('GameLogic.hasSolution', () {
    test('simple solvable board has solution', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.up, id: 'a1'), null, null],
        [null, Arrow(row: 1, col: 1, direction: Direction.down, id: 'a2'), null],
        [null, null, null],
      ];
      expect(GameLogic.hasSolution(board), isTrue);
    });
  });

  group('GameLogic.findHintArrow', () {
    test('returns hint for board with removable arrows', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.up, id: 'a1'), null, null],
        [null, Arrow(row: 1, col: 1, direction: Direction.down, id: 'a2'), null],
        [null, null, null],
      ];
      final hint = GameLogic.findHintArrow(board);
      expect(hint, isNotNull);
    });

    test('returns null for unsolvable situation', () {
      final board = [
        [Arrow(row: 0, col: 0, direction: Direction.right, id: 'a1'), Arrow(row: 0, col: 1, direction: Direction.left, id: 'a2'), null],
      ];
      final hint = GameLogic.findHintArrow(board);
      expect(hint, isNull);
    });
  });
}
