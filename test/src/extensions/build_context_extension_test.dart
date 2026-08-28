import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_easy_theme/src/theme_controller.dart';
import 'package:flutter_easy_theme/src/theme_scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeStorage extends Mock implements EasyThemeStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  group('EasyThemeExtension', () {
    late MockThemeStorage storage;
    late ThemeController controller;
    late ThemeData lightTheme;
    late ThemeData darkTheme;

    setUp(() {
      storage = MockThemeStorage();

      when(() => storage.saveThemeMode(any())).thenAnswer((_) async {});

      controller = ThemeController(
        storage: storage,
        platformBrightness: Brightness.light,
      );

      lightTheme = ThemeData.light();
      darkTheme = ThemeData.dark();
    });

    group('getters', () {
      testWidgets('should access theme properties via context', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ThemeScope(
              controller: controller,
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text('mode: ${context.themeMode.name}'),
                      Text('hasLight: ${context.lightTheme == lightTheme}'),
                      Text('hasDark: ${context.darkTheme == darkTheme}'),
                      Text(
                        'hasWatchController: ${context.watchTheme == controller}',
                      ),
                      Text(
                        'hasReadController: ${context.readTheme == controller}',
                      ),
                      Text('isDark: ${context.isDark}'),
                      Text('isLight: ${context.isLight}'),
                      Text(
                        'easyColor: ${context.easyColor(lColor: Colors.white, dColor: Colors.black) == Colors.white}',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('mode: system'), findsOneWidget);
        expect(find.text('hasLight: true'), findsOneWidget);
        expect(find.text('hasDark: true'), findsOneWidget);
        expect(find.text('hasWatchController: true'), findsOneWidget);
        expect(find.text('hasReadController: true'), findsOneWidget);
        expect(find.text('isDark: false'), findsOneWidget);
        expect(find.text('isLight: true'), findsOneWidget);
        expect(find.text('easyColor: true'), findsOneWidget);
      });

      testWidgets(
        'watchTheme should trigger rebuild when controller notifies',
        (tester) async {
          int rebuildCount = 0;
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeScope(
                controller: controller,
                lightTheme: lightTheme,
                darkTheme: darkTheme,
                child: Builder(
                  builder: (context) {
                    rebuildCount++;
                    context.watchTheme;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          );

          expect(rebuildCount, 1);

          controller.setThemeMode(ThemeMode.dark);
          await tester.pump();

          expect(rebuildCount, 2);
        },
      );

      testWidgets(
        'readTheme should not trigger rebuild when controller notifies',
        (tester) async {
          int rebuildCount = 0;
          await tester.pumpWidget(
            MaterialApp(
              home: ThemeScope(
                controller: controller,
                lightTheme: lightTheme,
                darkTheme: darkTheme,
                child: Builder(
                  builder: (context) {
                    rebuildCount++;
                    context.readTheme;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          );

          expect(rebuildCount, 1);

          controller.setThemeMode(ThemeMode.dark);
          await tester.pump();

          expect(rebuildCount, 1);
        },
      );
    });

    group('methods', () {
      testWidgets('should set dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ThemeScope(
              controller: controller,
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.setThemeModeToDark(),
                    child: const Text('dark'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('dark'));

        expect(controller.mode, ThemeMode.dark);
        verify(() => storage.saveThemeMode(ThemeMode.dark)).called(1);
      });

      testWidgets('should set light theme', (tester) async {
        controller.setThemeModeToDark();

        await tester.pumpWidget(
          MaterialApp(
            home: ThemeScope(
              controller: controller,
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.setThemeModeToLight(),
                    child: const Text('light'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('light'));

        expect(controller.mode, ThemeMode.light);
        verify(() => storage.saveThemeMode(ThemeMode.light)).called(1);
      });

      testWidgets('should set system theme', (tester) async {
        controller.setThemeModeToDark();

        await tester.pumpWidget(
          MaterialApp(
            home: ThemeScope(
              controller: controller,
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.setThemeModeToSystem(),
                    child: const Text('system'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('system'));

        expect(controller.mode, ThemeMode.system);
        verify(() => storage.saveThemeMode(ThemeMode.system)).called(1);
      });

      testWidgets('should toggle theme', (tester) async {
        controller.setThemeModeToLight();

        await tester.pumpWidget(
          MaterialApp(
            home: ThemeScope(
              controller: controller,
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.toggleTheme(),
                    child: const Text('toggle'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('toggle'));

        expect(controller.mode, ThemeMode.dark);
        verify(() => storage.saveThemeMode(ThemeMode.dark)).called(1);
      });

      testWidgets('should set theme mode', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ThemeScope(
              controller: controller,
              lightTheme: lightTheme,
              darkTheme: darkTheme,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.setThemeMode(ThemeMode.dark),
                    child: const Text('set'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('set'));

        expect(controller.mode, ThemeMode.dark);
        verify(() => storage.saveThemeMode(ThemeMode.dark)).called(1);
      });
    });

    group('errors', () {
      testWidgets('should throw assertion when ThemeScope is missing', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(() => context.watchTheme, throwsAssertionError);
                expect(() => context.readTheme, throwsAssertionError);
                expect(() => context.themeMode, throwsAssertionError);
                expect(() => context.lightTheme, throwsAssertionError);
                expect(() => context.darkTheme, throwsAssertionError);

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });
}
