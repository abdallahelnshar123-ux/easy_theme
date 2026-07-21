import 'package:flutter/material.dart';

import 'theme_controller.dart';

/// [ThemeScope] is an [InheritedNotifier] that provides access to the
/// [ThemeController] and theme data to its descendants.
class ThemeScope extends InheritedNotifier<ThemeController> {
  /// Creates a [ThemeScope].
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required this.lightTheme,
    required this.darkTheme,
    required super.child,
  }) : super(notifier: controller);

  /// The light theme configuration.
  final ThemeData lightTheme;

  /// The dark theme configuration.
  final ThemeData darkTheme;

  /// Returns the nearest [ThemeScope] ancestor in the widget tree, if any.
  static ThemeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeScope>();
  }

  /// Returns the nearest [ThemeScope] ancestor in the widget tree.
  ///
  /// Throws an assertion error if no [ThemeScope] is found.
  static ThemeScope of(BuildContext context) {
    final scope = maybeOf(context);

    assert(scope != null, 'No EasyTheme found in context.');

    return scope!;
  }
}
