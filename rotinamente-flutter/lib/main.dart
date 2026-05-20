import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const RotinamenteApp());
}

class RotinamenteApp extends StatelessWidget {
  const RotinamenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7B74FF),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rotinamente',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}
