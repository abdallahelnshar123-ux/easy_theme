import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyTheme.ensureInitialized();

  runApp(
    EasyTheme(
      lightTheme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.lightTheme,
      darkTheme: context.darkTheme,
      themeMode: context.themeMode,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Easy Theme')),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: () {
                context.toggleTheme();
              },
              child: const Text('Toggle Theme'),
            ),
            ElevatedButton(
              onPressed: () {
                context.setThemeModeToLight();
              },
              child: const Text('Set to light'),
            ),
            ElevatedButton(
              onPressed: () {
                context.setThemeModeToDark();
              },
              child: const Text('Set to dark'),
            ),
            ElevatedButton(
              onPressed: () {
                context.setThemeModeToSystem();
              },
              child: const Text('Set to system'),
            ),
          ],
        ),
      ),
    );
  }
}
