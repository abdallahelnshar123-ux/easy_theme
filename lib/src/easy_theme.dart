import 'package:easy_theme/src/shared_prefs_theme_storage.dart';
import 'package:easy_theme/src/theme_controller.dart';
import 'package:easy_theme/src/theme_scope.dart';
import 'package:easy_theme/src/theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [EasyTheme] is a widget that provides theme management capabilities to its child.
///
/// It handles theme switching, persistence, and provides access to the current
/// theme state via [BuildContext].
///
/// Example usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await EasyTheme.ensureInitialized();
///   runApp(
///     EasyTheme(
///       lightTheme: ThemeData.light(),
///       darkTheme: ThemeData.dark(),
///       child: const MyApp(),
///     ),
///   );
/// }
/// ```
class EasyTheme extends StatefulWidget {
  /// The theme to use when [ThemeMode.light] is active.
  final ThemeData lightTheme;

  /// The theme to use when [ThemeMode.dark] is active.
  final ThemeData darkTheme;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The initial [ThemeMode] to use if no theme has been saved yet.
  /// Defaults to [ThemeMode.system].
  final ThemeMode initialThemeMode;

  const EasyTheme({
    super.key,
    required this.lightTheme,
    required this.darkTheme,
    required this.child,
    this.initialThemeMode = ThemeMode.system,
  });

  /// Returns the saved [ThemeMode] from storage.
  static ThemeMode get savedThemeMode {
    return _storage.loadThemeMode();
  }

  static late ThemeStorage _themeStorage;
  static bool _initialized = false;

  /// Initializes the [EasyTheme] storage.
  ///
  /// This must be called before [runApp] if you want to load the saved theme
  /// correctly on startup.
  static Future<void> ensureInitialized() async {
    final preferences = await SharedPreferences.getInstance();
    _themeStorage = SharedPreferencesThemeStorage(preferences);
    _initialized = true;
  }

  /// Returns the [ThemeStorage] instance used by [EasyTheme].
  ///
  /// Throws an assertion error if [ensureInitialized] has not been called.
  static ThemeStorage get _storage {
    assert(_initialized, 'Call EasyTheme.ensureInitialized() before runApp().');

    return _themeStorage;
  }

  @override
  State<EasyTheme> createState() => _EasyThemeState();
}

class _EasyThemeState extends State<EasyTheme> with WidgetsBindingObserver {
  late final ThemeController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = ThemeController(
      storage: EasyTheme._storage,
      initialThemeMode: EasyTheme.savedThemeMode == ThemeMode.system
          ? widget.initialThemeMode
          : EasyTheme.savedThemeMode,
      platformBrightness:
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _controller.updatePlatformBrightness(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _controller,
      lightTheme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      child: widget.child,
    );
  }
}
