import 'package:flutter/material.dart';

import '../components/adaptive_scaffold.dart';
import 'applications_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

/// Halaman induk yang menyimpan tab terpilih dan menampilkan halaman yang sesuai.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Urutan harus sama dengan appDestinations di utils/app_destinations.dart.
  static const List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ApplicationsPage(),
    ProfilePage(),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      // IndexedStack menjaga state tiap halaman saat berpindah tab
      // (berguna nanti untuk teks pencarian dan filter).
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}