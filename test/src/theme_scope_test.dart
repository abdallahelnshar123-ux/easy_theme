import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/src/theme_controller.dart';
import 'package:flutter_easy_theme/src/theme_scope.dart';
import 'package:flutter_easy_theme/src/easy_theme_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeStorage extends Mock implements EasyThemeStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  group('ThemeScope', () {
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

    testWidgets('should provide controller and themes to descendants', (
      tester,
    ) async {
      late ThemeController providedController;
      late ThemeData providedLightTheme;
      late ThemeData providedDarkTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: ThemeScope(
            controller: controller,
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            child: Builder(
              builder: (context) {
                final scope = ThemeScope.of(context);

                providedController = scope.notifier!;
                providedLightTheme = scope.lightTheme;
                providedDarkTheme = scope.darkTheme;

                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(providedController, same(controller));
      expect(providedLightTheme, same(lightTheme));
      expect(providedDarkTheme, same(darkTheme));
    });

    testWidgets('maybeOf should return the current ThemeScope', (tester) async {
      late ThemeScope scope;
      late ThemeScope? maybeScope;

      await tester.pumpWidget(
        MaterialApp(
          home: ThemeScope(
            controller: controller,
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            child: Builder(
              builder: (context) {
                scope = ThemeScope.of(context);
                maybeScope = ThemeScope.maybeOf(context);

                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(maybeScope, isNotNull);
      expect(identical(scope, maybeScope), isTrue);
    });

    testWidgets('maybeOf should return null if no ThemeScope is found', (
      tester,
    ) async {
      ThemeScope? providedScope;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              providedScope = ThemeScope.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(providedScope, isNull);
    });

    testWidgets('of should throw assertion error if no ThemeScope is found', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(() => ThemeScope.of(context), throwsAssertionError);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    group('read', () {
      testWidgets('should return ThemeScope without registering dependency', (
        tester,
      ) async {
        int buildCount = 0;
        late ThemeScope readScope;

        await tester.pumpWidget(
          MaterialApp(
            home: ThemeScope(
              controller: controller,
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
        expect(readScope, isNotNull);
        expect(readScope.notifier, same(controller));

        // Trigger change - buildCount should not increase because read() was used
        controller.setThemeMode(ThemeMode.dark);
        await tester.pump();

        expect(buildCount, 1);
      });

      testWidgets('should throw assertion error if no ThemeScope is found', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(() => ThemeScope.read(context), throwsAssertionError);

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });
}
