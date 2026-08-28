import 'package:flutter/material.dart';

import '../theme_controller.dart';
import '../theme_scope.dart';

/// Extension methods for [BuildContext] to easily access [EasyTheme] features.
extension EasyThemeExtension on BuildContext {
  /// Returns the [ThemeController] from the nearest [ThemeScope]
  /// and registers this context to rebuild when the theme changes.
  ThemeController get watchTheme {
    return ThemeScope.of(this).notifier!;
  }

  /// Returns the current [ThemeMode].
  ThemeMode get themeMode {
    return watchTheme.mode;
  }

  /// Returns the [lightTheme] from the nearest [ThemeScope].
  ThemeData get lightTheme {
    return ThemeScope.of(this).lightTheme;
  }

  /// Returns the [darkTheme] from the nearest [ThemeScope].
  ThemeData get darkTheme {
    return ThemeScope.of(this).darkTheme;
  }

  /// Returns `true` if the current effective theme is dark.
  bool get isDark => watchTheme.isDark;

  /// Returns `true` if the current effective theme is light.
  bool get isLight => watchTheme.isLight;

  /// Returns [dColor] if the current theme is dark, and [lColor] otherwise.
  ///
  /// This provides a clean and concise way to define adaptive colors directly in your widgets.
  ///
  /// Example:
  /// ```dart
  /// Container(
  ///   color: context.easyColor(lColor: Colors.blue, dColor: Colors.indigo),
  /// )
  /// ```
  Color easyColor({required Color lColor, required Color dColor}) =>
      watchTheme.easyColor(lColor: lColor, dColor: dColor);

  /// Returns the [ThemeController] from the nearest [ThemeScope]
  /// without registering this context for theme changes.
  ThemeController get readTheme {
    return ThemeScope.read(this).notifier!;
  }

  /// Sets the theme mode.
  void setThemeMode(ThemeMode mode) {
    readTheme.setThemeMode(mode);
  }

  /// Sets the theme mode to [ThemeMode.dark].
  void setThemeModeToDark() {
    readTheme.setThemeModeToDark();
  }

  /// Sets the theme mode to [ThemeMode.light].
  void setThemeModeToLight() {
    readTheme.setThemeModeToLight();
  }

  /// Sets the theme mode to [ThemeMode.system].
  void setThemeModeToSystem() {
    readTheme.setThemeModeToSystem();
  }

  /// Toggles between light and dark themes.
  void toggleTheme() {
    readTheme.toggle();
  }
}
