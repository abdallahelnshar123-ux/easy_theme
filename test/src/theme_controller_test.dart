import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_easy_theme/src/easy_theme_storage.dart';
import 'package:flutter_easy_theme/src/theme_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeStorage extends Mock implements EasyThemeStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  group('ThemeController', () {
    late EasyThemeStorage storage;
    late ThemeController controller;

    setUp(() {
      storage = MockThemeStorage();
      when(() => storage.saveThemeMode(any())).thenAnswer((_) async {});

      controller = ThemeController(
        storage: storage,
        platformBrightness: Brightness.light,
      );
    });

    test('should have initialThemeMode as system by default', () {
      expect(controller.mode, ThemeMode.system);
    });

    test(
      'should update mode and save to storage when setThemeMode is called',
      () {
        controller.setThemeMode(ThemeMode.dark);

        expect(controller.mode, ThemeMode.dark);
        verify(() => storage.saveThemeMode(ThemeMode.dark)).called(1);
        verifyNoMoreInteractions(storage);
      },
    );

    test('should not notify listeners or save if mode is the same', () {
      var notified = false;
      controller.addListener(() => notified = true);

      controller.setThemeMode(ThemeMode.system);

      expect(notified, isFalse);
      verifyZeroInteractions(storage);
    });

    test('should notify listeners and save to storage when mode changes', () {
      var notified = false;
      controller.addListener(() => notified = true);

      controller.setThemeMode(ThemeMode.light);

      expect(notified, isTrue);
      expect(controller.mode, ThemeMode.light);
      verify(() => storage.saveThemeMode(ThemeMode.light)).called(1);
    });

    test('setThemeModeToDark should set mode to dark', () {
      controller.setThemeModeToDark();
      expect(controller.mode, ThemeMode.dark);
    });

    test('setThemeModeToLight should set mode to light', () {
      controller.setThemeModeToLight();
      expect(controller.mode, ThemeMode.light);
    });

    test('setThemeModeToSystem should set mode to system', () {
      controller.setThemeMode(ThemeMode.light);
      controller.setThemeModeToSystem();
      expect(controller.mode, ThemeMode.system);
    });

    group('toggle', () {
      test('should toggle from light to dark', () {
        controller.setThemeMode(ThemeMode.light);
        controller.toggle();
        expect(controller.mode, ThemeMode.dark);
      });

      test('should toggle from dark to light', () {
        controller.setThemeMode(ThemeMode.dark);
        controller.toggle();
        expect(controller.mode, ThemeMode.light);
      });

      test('should do nothing when mode is system', () {
        controller.setThemeMode(ThemeMode.system);
        controller.toggle();
        expect(controller.mode, ThemeMode.system);
      });
    });

    test(
      'updatePlatformBrightness should notify listeners when mode is system',
      () {
        var notified = false;
        controller.addListener(() => notified = true);

        controller.updatePlatformBrightness(Brightness.dark);

        expect(notified, isTrue);
      },
    );

    group('isDark and isLight', () {
      test('should return correct values when mode is system', () {
        controller = ThemeController(
          storage: storage,
          platformBrightness: Brightness.light,
        );
        expect(controller.isDark, isFalse);
        expect(controller.isLight, isTrue);

        controller.updatePlatformBrightness(Brightness.dark);
        expect(controller.isDark, isTrue);
        expect(controller.isLight, isFalse);
      });

      test('should return correct values when mode is light', () {
        controller.setThemeModeToLight();
        expect(controller.isDark, isFalse);
        expect(controller.isLight, isTrue);
      });

      test('should return correct values when mode is dark', () {
        controller.setThemeModeToDark();
        expect(controller.isDark, isTrue);
        expect(controller.isLight, isFalse);
      });
    });

    group('easyColor', () {
      const lightColor = Colors.white;
      const darkColor = Colors.black;

      test('should return lightColor when theme is light', () {
        controller.setThemeModeToLight();
        expect(
          controller.easyColor(lColor: lightColor, dColor: darkColor),
          lightColor,
        );
      });

      test('should return darkColor when theme is dark', () {
        controller.setThemeModeToDark();
        expect(
          controller.easyColor(lColor: lightColor, dColor: darkColor),
          darkColor,
        );
      });

      test('should adapt when mode is system', () {
        controller = ThemeController(
          storage: storage,
          platformBrightness: Brightness.light,
        );
        expect(
          controller.easyColor(lColor: lightColor, dColor: darkColor),
          lightColor,
        );

        controller.updatePlatformBrightness(Brightness.dark);
        expect(
          controller.easyColor(lColor: lightColor, dColor: darkColor),
          darkColor,
        );
      });
    });

    test('should use provided initialThemeMode', () {
      controller = ThemeController(
        storage: storage,
        platformBrightness: Brightness.light,
        initialThemeMode: ThemeMode.dark,
      );

      expect(controller.mode, ThemeMode.dark);
    });

    test(
      'updatePlatformBrightness should not notify when brightness does not change',
      () {
        var notifications = 0;

        controller.addListener(() {
          notifications++;
        });

        controller.updatePlatformBrightness(Brightness.light);

        expect(notifications, 0);
      },
    );

    test('setThemeModeToDark should save to storage', () {
      controller.setThemeModeToDark();

      verify(() => storage.saveThemeMode(ThemeMode.dark)).called(1);
    });

    test('setThemeModeToLight should save to storage', () {
      controller.setThemeModeToLight();

      verify(() => storage.saveThemeMode(ThemeMode.light)).called(1);
    });

    test('setThemeModeToSystem should save to storage', () {
      controller.setThemeMode(ThemeMode.dark);

      controller.setThemeModeToSystem();

      verify(() => storage.saveThemeMode(ThemeMode.system)).called(1);
    });

    test('toggle should save dark theme', () {
      controller.setThemeMode(ThemeMode.light);
      clearInteractions(storage);

      controller.toggle();

      expect(controller.mode, ThemeMode.dark);
      verify(() => storage.saveThemeMode(ThemeMode.dark)).called(1);
    });

    test('toggle should save light theme', () {
      controller.setThemeMode(ThemeMode.dark);
      clearInteractions(storage);

      controller.toggle();

      expect(controller.mode, ThemeMode.light);
      verify(() => storage.saveThemeMode(ThemeMode.light)).called(1);
    });
    test(
      'updatePlatformBrightness should not notify listeners when mode is not system',
      () {
        controller.setThemeMode(ThemeMode.light);
        var notified = false;
        controller.addListener(() => notified = true);

        controller.updatePlatformBrightness(Brightness.dark);

        expect(notified, isFalse);
      },
    );
  });
}
