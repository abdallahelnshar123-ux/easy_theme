import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/src/easy_theme_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [EasyThemeStorage] using [SharedPreferences].
class SharedPreferencesThemeStorage implements EasyThemeStorage {
  final SharedPreferences _preferences;

  /// Creates a [SharedPreferencesThemeStorage] with the given [preferences].
  SharedPreferencesThemeStorage(this._preferences);

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _preferences.setString(themeModeKey, mode.name);
  }

  @override
  Future<ThemeMode?> loadThemeMode() async {
    try {
      final theme = _preferences.getString(themeModeKey);

      if (theme == null) return null;

      return ThemeMode.values.firstWhere((mode) => mode.name == theme);
    } catch (_) {
      return null;
    }
  }

  @override
  String get themeModeKey => 'theme_mode';
}
