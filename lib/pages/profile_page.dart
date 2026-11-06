import 'package:flutter/material.dart';

import '../components/placeholder_section.dart';

/// Profil. Placeholder, dikerjakan di Fitur 7.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderSection(
      icon: Icons.person_outline,
      title: 'Profil',
      description: 'Profil dan keterampilanmu akan tampil di sini.',
      featureLabel: 'Dikerjakan di Fitur 7',
    );
  }
}