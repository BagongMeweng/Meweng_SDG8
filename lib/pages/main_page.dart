import 'package:flutter/material.dart';

import '../components/adaptive_scaffold.dart';
import '../services/auth_services.dart'; // Pastikan ini di-import
import 'applications_page.dart';
import 'home_page.dart';
import 'login_page.dart'; // Pastikan ini di-import
import 'profile_page.dart';
import 'search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ApplicationsPage(),
    ProfilePage(),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  // 1. TAMBAHKAN FUNGSI _handleLogout DI SINI
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout(); // Hapus sesi
      if (!mounted) return;

      // Kembali ke LoginPage dan bersihkan history
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      onLogout: _handleLogout, // 2. MASUKKAN PARAMETER INI DI SINI
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}