import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RotinamenteApp());
}

class RotinamenteApp extends StatelessWidget {
  const RotinamenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rotinamente',
      theme: AppTheme.light(),
      home: const HomePage(),
    );
  }
}
