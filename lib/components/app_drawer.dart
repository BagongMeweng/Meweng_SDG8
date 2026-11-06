import 'package:flutter/material.dart';

import '../utils/app_destinations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onLogout, // 1. TAMBAHKAN PARAMETER INI DI CONSTRUCTOR
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onLogout; // 2. DEKLARASIKAN VARIABELNYA

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Gunakan Column agar kita bisa meletakkan tombol Logout di paling bawah
      child: Column(
        children: [
          // Header Drawer (opsional, sesuaikan dengan punyamu)
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Center(
              child: Text(
                'Meweng',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Daftar Menu Navigasi (Gunakan Expanded agar bisa di-scroll)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < appDestinations.length; i++)
                  ListTile(
                    leading: Icon(
                      selectedIndex == i
                          ? appDestinations[i].selectedIcon
                          : appDestinations[i].icon,
                    ),
                    title: Text(appDestinations[i].label),
                    selected: selectedIndex == i,
                    onTap: () {
                      Navigator.pop(context); // Tutup drawer
                      onDestinationSelected(i); // Pindah halaman
                    },
                  ),
              ],
            ),
          ),

          // 3. TOMBOL LOGOUT DI PALING BAWAH
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Keluar Akun',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context); // Tutup drawer dulu
              onLogout(); // Panggil fungsi logout yang dikirim dari MainPage
            },
          ),
          const SizedBox(height: 16), // Jarak aman dari bawah layar
        ],
      ),
    );
  }
}