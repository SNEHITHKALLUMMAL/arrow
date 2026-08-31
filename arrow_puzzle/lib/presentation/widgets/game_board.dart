import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../providers/game_provider.dart';
import 'arrow_tile.dart';
import 'removal_animation.dart';

/// The main game board that displays the arrow grid.
class GameBoard extends ConsumerWidget {
  final LevelState levelState;

  const GameBoard({
    super.key,
    required this.levelState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.read(gameProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Calculate cell size to fit the board
        final cellW = maxWidth / levelState.cols;
        final cellH = maxHeight / levelState.rows;
        final cellSize = min(cellW, cellH);

        final boardWidth = cellSize * levelState.cols;
        final boardHeight = cellSize * levelState.rows;

        return Center(
          child: SizedBox(
            width: boardWidth,
            height: boardHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Board background
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                ),

                // Grid of cells
                for (int r = 0; r < levelState.rows; r++)
                  for (int c = 0; c < levelState.cols; c++)
                    Positioned(
                      left: c * cellSize,
                      top: r * cellSize,
                      width: cellSize,
                      height: cellSize,
                      child: _buildCell(
                        context,
                        r,
                        c,
                        cellSize,
                        levelState.board[r][c],
                        levelState,
                        game,
                      ),
                    ),

                // Removal animation overlay
                if (levelState.animatingArrow != null)
                  Positioned(
                    left: 0,
                    top: 0,
                    width: boardWidth,
                    height: boardHeight,
                    child: RemovalAnimation(
                      arrow: levelState.animatingArrow!,
                      cellSize: cellSize,
                      boardWidth: boardWidth,
                      boardHeight: boardHeight,
                      isFailed: levelState.phase == GamePhase.lost,
                      onComplete: () => game.completeRemoval(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(
    BuildContext context,
    int row,
    int col,
    double cellSize,
    Arrow? arrow,
    LevelState state,
    GameController game,
  ) {
    // Skip the cell that's currently animating
    if (state.animatingArrow != null &&
        state.animatingArrow!.row == row &&
        state.animatingArrow!.col == col) {
      return const SizedBox.shrink();
    }

    if (arrow == null) {
      return const SizedBox.shrink();
    }

    return ArrowTile(
      arrow: arrow,
      cellSize: cellSize,
      isHinted: state.hintArrow?.id == arrow.id,
      isFailed: state.phase == GamePhase.lost,
      onTap: () {
        final result = game.tapArrow(row, col);
        // The UI will rebuild based on state changes
      },
    );
  }
}
