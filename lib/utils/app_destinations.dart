import 'package:flutter/material.dart';
class AppDestination {
  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const List<AppDestination> appDestinations = [
  AppDestination(
    label: 'Beranda',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  AppDestination(
    label: 'Cari Lowongan',
    icon: Icons.search,
    selectedIcon: Icons.search,
  ),
  AppDestination(
    label: 'Lamaran Saya',
    icon: Icons.assignment_outlined,
    selectedIcon: Icons.assignment,
  ),
  AppDestination(
    label: 'Profil',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
  ),
];