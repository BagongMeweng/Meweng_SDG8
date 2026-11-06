import 'package:flutter/material.dart';

import '../utils/app_destinations.dart';
import 'app_brand.dart';

/// Drawer Material 3 yang hanya dipakai di layar kecil (compact).
/// Di layar lebar, fungsinya digantikan NavigationRail.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        // Tutup drawer dulu, lalu pindah halaman.
        Navigator.of(context).pop();
        onDestinationSelected(index);
      },
      children: [
        // Inset 28 mengikuti spesifikasi Material 3 agar sejajar dengan ikon menu.
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBrand(),
              const SizedBox(height: 8),
              Text(
                'Cari pekerjaan layak untuk semua',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        for (final destination in appDestinations)
          NavigationDrawerDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: Text(destination.label),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 16, 16),
          child: Text(
            'SDG 8 · Pekerjaan Layak dan Pertumbuhan Ekonomi',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}