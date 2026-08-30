import 'arrow.dart';

/// Represents a single puzzle level.
class Level {
  final int id;
  final String name;
  final int rows;
  final int cols;
  final List<Arrow> arrows;
  final int initialLives;
  final int difficulty; // 1-5
  final bool isTutorial;
  final String? tutorialMessage;
  final int hintsAvailable;

  const Level({
    required this.id,
    required this.name,
    required this.rows,
    required this.cols,
    required this.arrows,
    this.initialLives = 3,
    this.difficulty = 1,
    this.isTutorial = false,
    this.tutorialMessage,
    this.hintsAvailable = 3,
  });

  /// Total number of arrows on the board.
  int get arrowCount => arrows.length;

  /// Serializes to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rows': rows,
        'cols': cols,
        'arrows': arrows.map((a) => a.toCompactJson()).toList(),
        'initialLives': initialLives,
        'difficulty': difficulty,
        'isTutorial': isTutorial,
        'tutorialMessage': tutorialMessage,
        'hintsAvailable': hintsAvailable,
      };

  /// Deserializes from a JSON map.
  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json['id'] as int,
        name: json['name'] as String? ?? 'Level ${json['id']}',
        rows: json['rows'] as int,
        cols: json['cols'] as int,
        arrows: (json['arrows'] as List)
            .map((a) => Arrow.fromCompactJson(
                  a as Map<String, dynamic>,
                  id: 'arrow_${a['r']}_${a['c']}',
                ))
            .toList(),
        initialLives: json['initialLives'] as int? ?? 3,
        difficulty: json['difficulty'] as int? ?? 1,
        isTutorial: json['isTutorial'] as bool? ?? false,
        tutorialMessage: json['tutorialMessage'] as String?,
        hintsAvailable: json['hintsAvailable'] as int? ?? 3,
      );

  /// Creates a board grid from this level's arrows.
  /// Returns a 2D list where each cell is either null or an Arrow.
  List<List<Arrow?>> createBoard() {
    final board = List.generate(
      rows,
      (r) => List<Arrow?>.filled(cols, null),
    );
    for (final arrow in arrows) {
      if (arrow.row >= 0 &&
          arrow.row < rows &&
          arrow.col >= 0 &&
          arrow.col < cols) {
        board[arrow.row][arrow.col] = arrow;
      }
    }
    return board;
  }
}
