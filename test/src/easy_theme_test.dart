// import 'package:easy_theme/src/easy_theme.dart';
// import 'package:easy_theme/src/theme_scope.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   group('EasyTheme', () {
//     late ThemeData lightTheme;
//     late ThemeData darkTheme;
//
//     setUp(() {
//       SharedPreferences.setMockInitialValues({});
//       lightTheme = ThemeData.light();
//       darkTheme = ThemeData.dark();
//     });
//
//     testWidgets('should throw assertion error if not initialized', (
//       tester,
//     ) async {
//       // We need to reset the static state if possible, but Dart doesn't make it easy.
//       // Assuming it's not initialized yet in a fresh test run if we don't call ensureInitialized.
//       // However, other tests might have called it.
//       // For the sake of this test, we'll try to use it and expect the assertion.
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: EasyTheme(
//             lightTheme: lightTheme,
//             darkTheme: darkTheme,
//             child: const SizedBox(),
//           ),
//         ),
//       );
//
//       expect(tester.takeException(), isAssertionError);
//     });
//
//     testWidgets('should initialize and build correctly', (tester) async {
//       await EasyTheme.ensureInitialized();
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: EasyTheme(
//             lightTheme: lightTheme,
//             darkTheme: darkTheme,
//             child: Builder(
//               builder: (context) {
//                 return Text(ThemeScope.of(context).notifier!.mode.name);
//               },
//             ),
//           ),
//         ),
//       );
//
//       expect(find.text('system'), findsOneWidget);
//     });
//
//     testWidgets('should use initialThemeMode if provided and no saved theme', (
//       tester,
//     ) async {
//       await EasyTheme.ensureInitialized();
//
//       await tester.pumpWidget(
//         MaterialApp(
//           home: EasyTheme(
//             lightTheme: lightTheme,
//             darkTheme: darkTheme,
//             initialThemeMode: ThemeMode.dark,
//             child: Builder(
//               builder: (context) {
//                 return Text(ThemeScope.of(context).notifier!.mode.name);
//               },
//             ),
//           ),
//         ),
//       );
//
//       expect(find.text('dark'), findsOneWidget);
//     });
//
//     test('savedThemeMode should return loaded value', () async {
//       SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
//       await EasyTheme.ensureInitialized();
//
//       expect(EasyTheme.savedThemeMode, ThemeMode.light);
//     });
//   });
// }

import 'package:easy_theme/src/easy_theme.dart';
import 'package:easy_theme/src/theme_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                return Text(ThemeScope.of(context).notifier!.mode.name);
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
                return Text(ThemeScope.of(context).notifier!.mode.name);
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
                return Text(ThemeScope.of(context).notifier!.mode.name);
              },
            ),
          ),
        ),
      );

      expect(find.text('light'), findsOneWidget);
    });

    test('savedThemeMode should return stored value', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});

      await EasyTheme.ensureInitialized();

      expect(EasyTheme.savedThemeMode, ThemeMode.dark);
    });

    test('savedThemeMode should return system when nothing is saved', () async {
      SharedPreferences.setMockInitialValues({});

      await EasyTheme.ensureInitialized();

      expect(EasyTheme.savedThemeMode, ThemeMode.system);
    });
  });
}
