import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/src/easy_theme_storage.dart';

/// [ThemeController] is responsible for managing the [ThemeMode] of the application.
///
/// It handles switching between Light, Dark, and System themes, and persists
/// the selection using the provided [EasyThemeStorage].
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
  final EasyThemeStorage _storage;
  ThemeMode _mode;

  /// Returns the current [ThemeMode].
  ThemeMode get mode => _mode;

  /// Returns `true` if the current effective theme is dark.
  ///
  /// It considers both the manual [mode] and the [platformBrightness]
  /// when the mode is set to [ThemeMode.system].
  bool get isDark {
    if (_mode == ThemeMode.system) {
      return _platformBrightness == Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  /// Returns `true` if the current effective theme is light.
  ///
  /// It considers both the manual [mode] and the [platformBrightness]
  /// when the mode is set to [ThemeMode.system].
  bool get isLight {
    if (_mode == ThemeMode.system) {
      return _platformBrightness == Brightness.light;
    }
    return _mode == ThemeMode.light;
  }

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
    notifyListeners();

    _saveThemeMode();
  }

  Future _saveThemeMode() async {
    try {
      await _storage.saveThemeMode(_mode);
    } catch (e) {
      assert(() {
        debugPrint('Failed to save theme mode: $e');
        return true;
      }());
    }
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

  /// Returns [dColor] if the current theme is dark, and [lColor] otherwise.
  ///
  /// This method is incredibly useful for on-the-fly color switching for
  /// properties that are not part of your global [ThemeData].
  ///
  /// Example:
  /// ```dart
  /// final cardColor = controller.easyColor(
  ///   lColor: Colors.white,
  ///   dColor: Colors.grey[800]!,
  /// );
  /// ```
  Color easyColor({required Color lColor, required Color dColor}) {
    return isDark ? dColor : lColor;
  }
}
