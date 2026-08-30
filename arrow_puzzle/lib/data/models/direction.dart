/// Enum representing the four cardinal directions for arrows.
enum Direction {
  up,
  down,
  left,
  right;

  /// Returns the delta (rowDelta, colDelta) for this direction.
  (int, int) get delta {
    switch (this) {
      case Direction.up:
        return (-1, 0);
      case Direction.down:
        return (1, 0);
      case Direction.left:
        return (0, -1);
      case Direction.right:
        return (0, 1);
    }
  }

  /// Returns a human-readable label.
  String get label {
    switch (this) {
      case Direction.up:
        return 'Up';
      case Direction.down:
        return 'Down';
      case Direction.left:
        return 'Left';
      case Direction.right:
        return 'Right';
    }
  }

  /// Returns the rotation angle in radians for rendering.
  double get angle {
    switch (this) {
      case Direction.up:
        return 0;
      case Direction.right:
        return 3.14159265 / 2;
      case Direction.down:
        return 3.14159265;
      case Direction.left:
        return -3.14159265 / 2;
    }
  }
}
