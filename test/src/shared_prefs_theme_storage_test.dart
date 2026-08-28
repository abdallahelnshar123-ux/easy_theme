import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/src/shared_prefs_theme_storage.dart';
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

    test('should expose the correct default storage key', () {
      expect(storage.themeModeKey, 'theme_mode');
    });

    test('should return null when no theme is saved', () async {
      expect(await storage.loadThemeMode(), null);
    });

    test('should return null when saved value is invalid', () async {
      await preferences.setString(storage.themeModeKey, 'invalid_mode');
      expect(await storage.loadThemeMode(), null);
    });

    test('should save and load light theme mode', () async {
      await storage.saveThemeMode(ThemeMode.light);

      expect(await storage.loadThemeMode(), ThemeMode.light);
      expect(preferences.getString(storage.themeModeKey), ThemeMode.light.name);
    });

    test('should save and load dark theme mode', () async {
      await storage.saveThemeMode(ThemeMode.dark);

      expect(await storage.loadThemeMode(), ThemeMode.dark);
      expect(preferences.getString(storage.themeModeKey), ThemeMode.dark.name);
    });

    test('should save and load system theme mode', () async {
      await storage.saveThemeMode(ThemeMode.system);

      expect(await storage.loadThemeMode(), ThemeMode.system);
      expect(
        preferences.getString(storage.themeModeKey),
        ThemeMode.system.name,
      );
    });

    test('should handle concurrent updates correctly', () async {
      // This test ensures that sequential saves don't conflict in a way that breaks loading
      await storage.saveThemeMode(ThemeMode.light);
      await storage.saveThemeMode(ThemeMode.dark);

      expect(await storage.loadThemeMode(), ThemeMode.dark);
    });

    test('clear should reset storage to system defaults', () async {
      await storage.saveThemeMode(ThemeMode.dark);
      expect(await storage.loadThemeMode(), ThemeMode.dark);

      await preferences.remove(storage.themeModeKey);
      expect(await storage.loadThemeMode(), null);
    });
  });
}
