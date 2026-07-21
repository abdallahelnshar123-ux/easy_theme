import 'package:easy_theme/src/theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [ThemeStorage] using [SharedPreferences].
class SharedPreferencesThemeStorage implements ThemeStorage {
  final SharedPreferences _preferences;

  /// Creates a [SharedPreferencesThemeStorage] with the given [preferences].
  SharedPreferencesThemeStorage(this._preferences);

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _preferences.setString(themeModeKey, mode.name);
  }

  @override
  ThemeMode loadThemeMode() {
    final theme = _preferences.getString(themeModeKey);

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == theme,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  String get themeModeKey => 'theme_mode';
}
