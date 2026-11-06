import 'package:flutter/material.dart';

import '../utils/app_destinations.dart';
import '../utils/responsive.dart';
import 'app_brand.dart';
import 'app_drawer.dart';

/// Kerangka halaman utama (Scaffold) yang menyesuaikan diri dengan ukuran layar:
/// - compact  : AppBar + Drawer + NavigationBar di bawah.
/// - medium   : NavigationRail di kiri (hanya ikon dan label).
/// - expanded : NavigationRail yang dilebarkan (ikon di samping label).
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final isCompact = screenSize == ScreenSize.compact;

        return Scaffold(
          appBar: AppBar(
            // Beranda menampilkan logo, halaman lain menampilkan nama halaman.
            title: selectedIndex == 0
                ? const AppBrand()
                : Text(appDestinations[selectedIndex].label),
          ),
          drawer: isCompact
              ? AppDrawer(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                )
              : null,
          body: isCompact
              ? body
              : Row(
                  children: [
                    _buildRail(extended: screenSize == ScreenSize.expanded),
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

  Widget _buildRail({required bool extended}) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      // Saat extended, label sudah tampil di samping ikon sehingga labelType harus none.
      labelType:
          extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      destinations: [
        for (final destination in appDestinations)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: Text(destination.label),
          ),
      ],
    );
  }
}