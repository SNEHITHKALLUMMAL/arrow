import 'package:flutter/material.dart';

/// Color constants for the Arrow Puzzle game.
class AppColors {
  AppColors._();

  // ── Primary Palette ──
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42DB);

  // ── Background Colors ──
  static const Color backgroundLight = Color(0xFFF5F3FF);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16213E);

  // ── Board Colors ──
  static const Color boardBackgroundLight = Color(0xFFEDE9FE);
  static const Color boardBackgroundDark = Color(0xFF0F3460);
  static const Color cellEmptyLight = Color(0xFFDDD6FE);
  static const Color cellEmptyDark = Color(0xFF1A1A3E);

  // ── Arrow Colors ──
  static const Color arrowUp = Color(0xFF6C63FF);
  static const Color arrowDown = Color(0xFFFF6584);
  static const Color arrowLeft = Color(0xFF43B581);
  static const Color arrowRight = Color(0xFFFFB347);

  // ── UI Colors ──
  static const Color success = Color(0xFF43B581);
  static const Color error = Color(0xFFFF5555);
  static const Color warning = Color(0xFFFFB347);
  static const Color star = Color(0xFFFFD700);
  static const Color life = Color(0xFFFF6584);
  static const Color hint = Color(0xFF00D2FF);

  // ── Text Colors ──
  static const Color textPrimaryLight = Color(0xFF1E1E2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF1F1F1);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // ── Overlay Colors ──
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0xB3000000);

  /// Returns the arrow color for a given direction index (0=up,1=down,2=left,3=right).
  static Color arrowColor(int directionIndex) {
    switch (directionIndex) {
      case 0:
        return arrowUp;
      case 1:
        return arrowDown;
      case 2:
        return arrowLeft;
      case 3:
        return arrowRight;
      default:
        return primary;
    }
  }
}
