import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'progress_provider.dart';
import '../../core/theme/app_theme.dart';

/// Provides the current theme mode based on user settings.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final progress = ref.watch(progressProvider);
  return progress.darkModeEnabled ? ThemeMode.dark : ThemeMode.light;
});

/// Provides the current ThemeData based on theme mode.
final currentThemeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.dark
      ? AppTheme.darkTheme()
      : AppTheme.lightTheme();
});
