import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'utils/app_theme.dart';
import 'services/auth_services.dart';
import 'pages/main_page.dart';
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
      // Gunakan FutureBuilder untuk mengecek status login
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          // Jika masih loading (mengecek memori)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // Jika sudah login, langsung ke MainPage
          if (snapshot.data == true) {
            return const MainPage();
          }
          
          // Jika belum login, ke LoginPage
          return const LoginPage();
        },
      ),
    );
  }
}