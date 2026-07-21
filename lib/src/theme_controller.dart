import 'package:easy_theme/src/theme_storage.dart';
import 'package:flutter/material.dart';

/// [ThemeController] is responsible for managing the [ThemeMode] of the application.
///
/// It handles switching between Light, Dark, and System themes, and persists
/// the selection using the provided [ThemeStorage].
///
/// See the `example/lib/main.dart` for a complete implementation.
class ThemeController extends ChangeNotifier {
  /// Creates a [ThemeController] with a required [storage] and [platformBrightness].
  ///
  /// [initialThemeMode] defaults to [ThemeMode.system] if not provided.
  ThemeController({
    required this._storage,
    required this._platformBrightness,

    ThemeMode initialThemeMode = ThemeMode.system,
  }) : _mode = initialThemeMode;

  Brightness _platformBrightness;
  final ThemeStorage _storage;
  ThemeMode _mode;

  /// Returns the current [ThemeMode].
  ThemeMode get mode => _mode;

  /// Updates the internal platform brightness state.
  ///
  /// This is usually called when the system's brightness changes (e.g., via `WidgetsBindingObserver`).
  void updatePlatformBrightness(Brightness brightness) {
    if (_platformBrightness == brightness) return;
    _platformBrightness = brightness;

    if (_mode == ThemeMode.system) {
      notifyListeners();
    }
  }

  /// Sets the [ThemeMode] and persists it to storage.
  ///
  /// If the new [mode] is the same as the current one, nothing happens.
  void setThemeMode(ThemeMode mode) {
    if (_mode == mode) return;

    _mode = mode;
    _storage.saveThemeMode(_mode);

    notifyListeners();
  }

  /// Convenience method to set the theme to [ThemeMode.dark].
  void setThemeModeToDark() => setThemeMode(ThemeMode.dark);

  /// Convenience method to set the theme to [ThemeMode.light].
  void setThemeModeToLight() => setThemeMode(ThemeMode.light);

  /// Convenience method to set the theme to [ThemeMode.system].
  void setThemeModeToSystem() => setThemeMode(ThemeMode.system);

  /// Toggles between [ThemeMode.light] and [ThemeMode.dark].
  ///
  /// If the current mode is set to [ThemeMode.system],
  /// [toggle] 'll have no effect.

  void toggle() {
    switch (_mode) {
      case ThemeMode.light:
        setThemeModeToDark();
        break;

      case ThemeMode.dark:
        setThemeModeToLight();
        break;

      case ThemeMode.system:
        return;
    }
  }
}
