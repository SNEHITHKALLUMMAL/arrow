import 'direction.dart';

/// Represents a single arrow on the game board.
class Arrow {
  final int row;
  final int col;
  final Direction direction;
  final String id;

  const Arrow({
    required this.row,
    required this.col,
    required this.direction,
    required this.id,
  });

  /// Creates a copy with optional field overrides.
  Arrow copyWith({
    int? row,
    int? col,
    Direction? direction,
    String? id,
  }) {
    return Arrow(
      row: row ?? this.row,
      col: col ?? this.col,
      direction: direction ?? this.direction,
      id: id ?? this.id,
    );
  }

  /// Serializes to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'row': row,
        'col': col,
        'direction': direction.index,
        'id': id,
      };

  /// Deserializes from a JSON map.
  factory Arrow.fromJson(Map<String, dynamic> json) => Arrow(
        row: json['row'] as int,
        col: json['col'] as int,
        direction: Direction.values[json['direction'] as int],
        id: json['id'] as String,
      );

  /// Serializes to compact JSON (for level definitions, no id needed).
  Map<String, dynamic> toCompactJson() => {
        'r': row,
        'c': col,
        'd': direction.index,
      };

  /// Deserializes from compact JSON, generating a unique id.
  factory Arrow.fromCompactJson(Map<String, dynamic> json, {String? id}) =>
      Arrow(
        row: json['r'] as int,
        col: json['c'] as int,
        direction: Direction.values[json['d'] as int],
        id: id ?? '${json['r']}_${json['c']}',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Arrow &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col &&
          direction == other.direction;

  @override
  int get hashCode => Object.hash(row, col, direction);

  @override
  String toString() => 'Arrow($row,$col,${direction.name})';
}
