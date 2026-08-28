import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_easy_theme/src/theme_scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockEasyThemeStorage implements EasyThemeStorage {
  ThemeMode? savedMode;

  @override
  String get themeModeKey => 'theme_mode';

  @override
  Future<ThemeMode?> loadThemeMode() async => savedMode;

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    savedMode = mode;
  }
}

void main() {
  group('EasyTheme', () {
    late ThemeData lightTheme;
    late ThemeData darkTheme;

    setUp(() {
      lightTheme = ThemeData.light();
      darkTheme = ThemeData.dark();
    });

    testWidgets('should initialize and build correctly', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await EasyTheme.ensureInitialized();

      await tester.pumpWidget(
        MaterialApp(
          home: EasyTheme(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            child: Builder(
              builder: (context) {
                return Text(context.themeMode.name);
              },
            ),
          ),
        ),
      );

      expect(find.text('system'), findsOneWidget);
    });

    testWidgets('should use initialThemeMode when no saved theme exists', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      await EasyTheme.ensureInitialized();

      await tester.pumpWidget(
        MaterialApp(
          home: EasyTheme(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            initialThemeMode: ThemeMode.dark,
            child: Builder(
              builder: (context) {
                return Text(context.themeMode.name);
              },
            ),
          ),
        ),
      );

      expect(find.text('dark'), findsOneWidget);
    });

    testWidgets('should prefer saved theme over initialThemeMode', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      await EasyTheme.ensureInitialized();

      await tester.pumpWidget(
        MaterialApp(
          home: EasyTheme(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            initialThemeMode: ThemeMode.dark,
            child: Builder(
              builder: (context) {
                return Text(context.themeMode.name);
              },
            ),
          ),
        ),
      );

      expect(find.text('light'), findsOneWidget);
    });

    testWidgets(
      'should update UI when theme changes using reactive extension',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        await EasyTheme.ensureInitialized();

        await tester.pumpWidget(
          MaterialApp(
            home: EasyTheme(
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text(context.themeMode.name),
                      ElevatedButton(
                        onPressed: () => context.setThemeModeToDark(),
                        child: const Text('Change to Dark'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('system'), findsOneWidget);

        await tester.tap(find.text('Change to Dark'));
        await tester.pumpAndSettle();

        expect(find.text('dark'), findsOneWidget);
      },
    );

    testWidgets('ThemeScope.read should return scope without dependency', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      await EasyTheme.ensureInitialized();

      int buildCount = 0;
      late ThemeScope readScope;

      await tester.pumpWidget(
        MaterialApp(
          home: EasyTheme(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            child: Builder(
              builder: (context) {
                buildCount++;
                readScope = ThemeScope.read(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, 1);

      // Change theme mode - should not trigger rebuild of the builder using ThemeScope.read
      readScope.notifier!.setThemeMode(ThemeMode.dark);
      await tester.pump();

      expect(buildCount, 1);
    });

    testWidgets('should support custom storage implementation', (tester) async {
      final mockStorage = MockEasyThemeStorage();
      mockStorage.savedMode = ThemeMode.dark;

      await EasyTheme.ensureInitialized(storage: mockStorage);

      await tester.pumpWidget(
        MaterialApp(
          home: EasyTheme(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => context.setThemeModeToLight(),
                  child: Text(context.themeMode.name),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('dark'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(mockStorage.savedMode, ThemeMode.light);
      expect(find.text('light'), findsOneWidget);
    });

    test(
      'savedThemeMode should return null when nothing is saved in default storage',
      () async {
        SharedPreferences.setMockInitialValues({});
        await EasyTheme.ensureInitialized();
        expect(EasyTheme.savedThemeMode, null);
      },
    );

    test(
      'savedThemeMode should return stored value in default storage',
      () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
        await EasyTheme.ensureInitialized();
        expect(EasyTheme.savedThemeMode, ThemeMode.dark);
      },
    );
  });
}
