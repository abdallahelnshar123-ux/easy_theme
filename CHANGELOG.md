## 1.1.0

- Added the `EasyThemeStorage` interface to support custom storage implementations, such as Hive or Secure Storage.
- Added support for providing a custom storage implementation to `EasyTheme.ensureInitialized`.
- Enhanced `BuildContext` extensions with reactive (`watch`) and non-reactive (`read`) access patterns.
- Fixed an issue where the saved theme mode could be incorrectly resolved during initialization.
- Improved documentation and examples for custom storage and context usage.

## 1.0.0

- Initial release.
- Added the `EasyTheme` widget for theme management.
- Added persistent theme storage using `SharedPreferences`.
- Added `BuildContext` extensions for convenient theme access and control.
- Supported `ThemeMode.light`, `ThemeMode.dark`, and `ThemeMode.system`.
- Automatically responded to system brightness changes.
- Added `easyColor` method to `BuildContext` for adaptive color handling.
- Added `isDark` and `isLight` getters to `BuildContext` for quick theme status checks.
