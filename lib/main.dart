import 'package:flutter/material.dart';

import 'pages/main_page.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MewengApp());
}

class MewengApp extends StatelessWidget {
  const MewengApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meweng',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Mengikuti pengaturan terang/gelap perangkat.
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}