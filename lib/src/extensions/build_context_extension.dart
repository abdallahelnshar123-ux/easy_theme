import 'package:flutter/material.dart';

import '../theme_controller.dart';
import '../theme_scope.dart';

/// Extension methods for [BuildContext] to easily access [EasyTheme] features.
extension EasyThemeExtension on BuildContext {
  /// Returns the [ThemeController] from the nearest [ThemeScope].
  ThemeController get theme {
    return ThemeScope.of(this).notifier!;
  }

  /// Returns the current [ThemeMode].
  ThemeMode get themeMode {
    return ThemeScope.of(this).notifier!.mode;
  }

  /// Returns the [lightTheme] from the nearest [ThemeScope].
  ThemeData get lightTheme {
    return ThemeScope.of(this).lightTheme;
  }

  /// Returns the [darkTheme] from the nearest [ThemeScope].
  ThemeData get darkTheme {
    return ThemeScope.of(this).darkTheme;
  }

  /// Sets the theme mode.
  void setThemeMode(ThemeMode mode) {
    theme.setThemeMode(mode);
  }

  /// Sets the theme mode to [ThemeMode.dark].
  void setThemeModeToDark() {
    theme.setThemeModeToDark();
  }

  /// Sets the theme mode to [ThemeMode.light].
  void setThemeModeToLight() {
    theme.setThemeModeToLight();
  }

  /// Sets the theme mode to [ThemeMode.system].
  void setThemeModeToSystem() {
    theme.setThemeModeToSystem();
  }

  /// Toggles between light and dark themes.
  void toggleTheme() {
    theme.toggle();
  }
}
