import 'package:flutter/material.dart';

/// Interface for theme persistence.
///
/// Implement this class to provide custom storage for the selected [ThemeMode].
abstract interface class ThemeStorage {
  /// The key used to store the theme mode.
  String get themeModeKey;

  /// Saves the [ThemeMode] to storage.
  Future<void> saveThemeMode(ThemeMode mode);

  /// Loads the [ThemeMode] from storage.
  ThemeMode loadThemeMode();
}
