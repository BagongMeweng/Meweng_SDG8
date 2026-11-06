import 'package:flutter/material.dart';

import '../utils/app_destinations.dart';
import '../utils/responsive.dart';
import '../utils/mock_data.dart'; // Tambahkan import ini untuk mockUser
import 'app_brand.dart';
import 'app_drawer.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    required this.onLogout,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final isCompact = screenSize == ScreenSize.compact;

        return Scaffold(
          appBar: AppBar(
            title: selectedIndex == 0
                ? const AppBrand()
                : Text(appDestinations[selectedIndex].label),
          ),
          drawer: isCompact
              ? AppDrawer(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  onLogout: onLogout,
                )
              : null,
          body: isCompact
              ? body
              : Row(
                  children: [
                    _buildRail(context, extended: screenSize == ScreenSize.expanded),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: body),
                  ],
                ),
          bottomNavigationBar: isCompact
              ? NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  destinations: [
                    for (final destination in appDestinations)
                      NavigationDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.selectedIcon),
                        label: destination.label,
                      ),
                  ],
                )
              : null,
        );
      },
    );
  }

  Widget _buildRail(BuildContext context, {required bool extended}) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      labelType:
          extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      
      // --- PLACEHOLDER PROFIL DI BAGIAN ATAS SIDEBAR ---
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: extended ? 30 : 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                mockUser.initials,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: extended ? 20 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (extended) ...[
              const SizedBox(height: 8),
              Text(
                mockUser.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Pencari Kerja',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ]
          ],
        ),
      ),

      destinations: [
        for (final destination in appDestinations)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: Text(destination.label),
          ),
      ],

      // --- TOMBOL LOGOUT DENGAN TEKS & EFEK HOVER DI BAGIAN BAWAH SIDEBAR ---
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: onLogout,
              borderRadius: BorderRadius.circular(8),
              // EFEK HOVER: Warna merah pudar saat kursor diarahkan
              hoverColor: Colors.red.withOpacity(0.1), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    // Tampilkan teks "Keluar" jika layar lebar (extended)
                    if (extended) ...[
                      const SizedBox(width: 12),
                      const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}