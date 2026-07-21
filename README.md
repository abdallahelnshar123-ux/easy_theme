# Easy Theme

A powerful and easy-to-use theme management package for Flutter. It provides seamless theme switching, persistence, and effortless access to theme states through `BuildContext` extensions.

## Demo

![Easy Theme Demo](https://raw.githubusercontent.com/your-username/easy_theme/main/screenshots/demo.gif)

## Features

-  **Easy Switching**: Toggle between light, dark, and system themes with a single line of code.
-  **Persistence**: Automatically saves and restores the user's theme preference using `SharedPreferences`.
-  **BuildContext Extensions**: Access theme properties and methods directly from the `context`.

## Getting started

Add `easy_theme` to your `pubspec.yaml`:

```yaml
dependencies:
  easy_theme: ^1.0.0
```

## Initialization

Before using `EasyTheme`, you **must** initialize the bindings and the package in your `main.dart` file. This ensures that the saved theme is loaded correctly before the app starts.

`EasyTheme.ensureInitialized()` only needs to be called once before `runApp()`.

```dart
void main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize EasyTheme storage
  await EasyTheme.ensureInitialized();

  runApp(
    EasyTheme(
      // You can pass default Flutter themes
      lightTheme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // OR your custom defined themes
      // lightTheme: AppThemes.light,
      // darkTheme: AppThemes.dark,
      child: const MyApp(),
    ),
  );
}
```

## Usage

###  Setting up MaterialApp

To make the themes take effect, you **must** pass the theme properties from the `EasyTheme` context to your `MaterialApp`.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Access themes and mode via context extensions
      theme: context.lightTheme,
      darkTheme: context.darkTheme,
      themeMode: context.themeMode,
      home: const HomePage(),
    );
  }
}
```

###  Important: Context Management

For `context.lightTheme`, `context.darkTheme`, and `context.themeMode` to be available, the `MaterialApp` should **not** be a direct child of the `EasyTheme` widget in the same `build` method. 

You have two options:

#### Option 1: Separate Widget (Recommended)
Extract your `MaterialApp` into a separate widget (as shown above) so it has its own `BuildContext` that can look up the `EasyTheme` scope.

#### Option 2: Using a `Builder`
If you want to keep everything in one place, use a `Builder` widget to provide a new context.

```dart
EasyTheme(
  lightTheme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  child: Builder(
    builder: (context) {
      return MaterialApp(
        theme: context.lightTheme,
        darkTheme: context.darkTheme,
        themeMode: context.themeMode,
        home: const HomePage(),
      );
    },
  ),
)
```

## BuildContext Extensions

`EasyTheme` provides convenient extensions on `BuildContext` to make theme management a breeze.

### Getters
- `context.themeMode`: Returns the current `ThemeMode` (light, dark, or system).
- `context.lightTheme`: Returns the provided light `ThemeData`.
- `context.darkTheme`: Returns the provided dark `ThemeData`.

### Methods
- `context.setThemeMode(ThemeMode mode)`: Sets a specific theme mode.
- `context.setThemeModeToLight()`: Switches to Light mode.
- `context.setThemeModeToDark()`: Switches to Dark mode.
- `context.setThemeModeToSystem()`: Switches to System mode.
- `context.toggleTheme()`: Toggles between Light and Dark modes.

## Important Notes

### `toggleTheme()` and System Mode
The `context.toggleTheme()` method is designed to switch between `ThemeMode.light` and `ThemeMode.dark`. 

**Note:** If the current `themeMode` is set to `ThemeMode.system`, calling `toggleTheme()` will have **no effect**. You should first set the theme to a specific mode if you wish to use the toggle functionality.

## Additional information

For a complete working example, please refer to the [example folder](https://github.com/your-repo/easy_theme/tree/main/example).

Contributions and feedback are welcome.
