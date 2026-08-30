# Arrow Puzzle 🎯

A relaxing logic puzzle game for Android and iOS, built with Flutter.

## 🎮 Gameplay

- A grid filled with arrows pointing in four directions (up, down, left, right)
- **Tap an arrow** to remove it — but only if the path in its direction is completely clear to the board edge
- Wrong taps cost a life (3 lives per level by default)
- Clear all arrows to win!
- Earn up to 3 stars per level based on your performance

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24+ 
- Dart SDK 3.5+
- Android Studio / Xcode

### Setup
```bash
cd arrow_puzzle
flutter pub get
flutter run
```

### Run Tests
```bash
flutter test
```

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp, routes, theme
├── core/
│   ├── constants/               # Colors, dimensions
│   ├── theme/                   # Light & dark themes
│   └── utils/                   # Pure game logic
├── data/
│   ├── models/                  # Arrow, Level, GameState, etc.
│   ├── datasources/             # SharedPreferences persistence
│   └── levels/                  # 60 handcrafted levels
└── presentation/
    ├── screens/                 # All app screens
    ├── widgets/                 # Reusable UI components
    └── providers/               # Riverpod state management
```

## 🧩 Architecture

- **State Management**: Riverpod with StateNotifier
- **Persistence**: shared_preferences for save/load
- **Game Logic**: Pure functions in `core/utils/game_logic.dart`
- **Models**: Immutable with copyWith pattern
- **Theme**: Material 3 with light/dark mode support

## 🎨 Adding New Levels

Levels are defined in `lib/data/levels/level_data.dart` as Dart constants.

### Level Format
```dart
Level(
  id: 61,                       // Unique ID (1-indexed)
  name: 'My Level',             // Display name
  rows: 4,                      // Grid height
  cols: 4,                      // Grid width
  difficulty: 2,                // 1-5 scale
  initialLives: 3,              // Lives for this level
  hintsAvailable: 3,            // Hints available
  isTutorial: false,            // Tutorial flag
  tutorialMessage: null,        // Tooltip text (if tutorial)
  arrows: [
    Arrow(row: 0, col: 0, direction: Direction.up, id: 'a1'),
    Arrow(row: 1, col: 1, direction: Direction.right, id: 'a2'),
    // ... more arrows
  ],
),
```

### Arrow Coordinates
- `row`: 0-indexed from top
- `col`: 0-indexed from left
- `direction`: `Direction.up`, `Direction.down`, `Direction.left`, `Direction.right`

### Ensuring Solvability
Every level MUST be solvable. The `GameLogic.hasSolution()` function verifies this:
```dart
final board = level.createBoard();
assert(GameLogic.hasSolution(board), 'Level ${level.id} is not solvable!');
```

## 🎨 Customizing Themes

Edit `lib/core/theme/app_theme.dart` and `lib/core/constants/app_colors.dart`.

Arrow colors by direction:
- **Up**: Purple (#6C63FF)
- **Down**: Pink (#FF6584)  
- **Left**: Green (#43B581)
- **Right**: Orange (#FFB347)

## 📊 Features

- ✅ 60 handcrafted levels with progressive difficulty
- ✅ 5 tutorial levels teaching core mechanics
- ✅ Daily challenge system with streak tracking
- ✅ Smooth animations (arrow slide-out, star earn, confetti)
- ✅ Light and dark mode
- ✅ Progress saving with SharedPreferences
- ✅ Hint system (finds best available move)
- ✅ Star rating (3 stars for perfect, no wasted lives)
- ✅ Responsive layout for phones and tablets
- ✅ Haptic feedback
- ✅ Ad and IAP placeholders ready for monetization

## 🔧 Tech Stack

| Feature | Package |
|---------|---------|
| State Management | flutter_riverpod |
| Persistence | shared_preferences |
| Fonts | google_fonts |
| Animations | flutter_animate |
| Date Formatting | intl |
| URL Launching | url_launcher |
| Testing | flutter_test |

## 📄 License

MIT License
