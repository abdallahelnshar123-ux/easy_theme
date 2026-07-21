// import 'package:easy_theme/src/shared_prefs_theme_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   group('SharedPreferencesThemeStorage', () {
//     late SharedPreferences preferences;
//     late SharedPreferencesThemeStorage storage;
//
//     setUp(() async {
//       SharedPreferences.setMockInitialValues({});
//       preferences = await SharedPreferences.getInstance();
//       storage = SharedPreferencesThemeStorage(preferences);
//     });
//
//     test('should return ThemeMode.system when no theme is saved', () {
//       expect(storage.loadThemeMode(), ThemeMode.system);
//     });
//
//     test('should save and load light theme mode', () async {
//       await storage.saveThemeMode(ThemeMode.light);
//       expect(storage.loadThemeMode(), ThemeMode.light);
//       expect(preferences.getString(storage.themeModeKey), 'light');
//     });
//
//     test('should save and load dark theme mode', () async {
//       await storage.saveThemeMode(ThemeMode.dark);
//       expect(storage.loadThemeMode(), ThemeMode.dark);
//       expect(preferences.getString(storage.themeModeKey), 'dark');
//     });
//
//     test('should save and load system theme mode', () async {
//       await storage.saveThemeMode(ThemeMode.system);
//       expect(storage.loadThemeMode(), ThemeMode.system);
//       expect(preferences.getString(storage.themeModeKey), 'system');
//     });
//   });
// }

import 'package:easy_theme/src/shared_prefs_theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesThemeStorage', () {
    late SharedPreferences preferences;
    late SharedPreferencesThemeStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      storage = SharedPreferencesThemeStorage(preferences);
    });

    test('should expose the correct storage key', () {
      expect(storage.themeModeKey, 'theme_mode');
    });

    test('should return ThemeMode.system when no theme is saved', () {
      expect(storage.loadThemeMode(), ThemeMode.system);
    });

    test(
      'should return ThemeMode.system when saved value is invalid',
      () async {
        await preferences.setString(storage.themeModeKey, 'invalid');

        expect(storage.loadThemeMode(), ThemeMode.system);
      },
    );

    test('should save and load light theme mode', () async {
      await storage.saveThemeMode(ThemeMode.light);

      expect(storage.loadThemeMode(), ThemeMode.light);
      expect(preferences.getString(storage.themeModeKey), ThemeMode.light.name);
    });

    test('should save and load dark theme mode', () async {
      await storage.saveThemeMode(ThemeMode.dark);

      expect(storage.loadThemeMode(), ThemeMode.dark);
      expect(preferences.getString(storage.themeModeKey), ThemeMode.dark.name);
    });

    test('should save and load system theme mode', () async {
      await storage.saveThemeMode(ThemeMode.system);

      expect(storage.loadThemeMode(), ThemeMode.system);
      expect(
        preferences.getString(storage.themeModeKey),
        ThemeMode.system.name,
      );
    });
  });
}
