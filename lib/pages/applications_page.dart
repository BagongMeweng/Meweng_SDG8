import 'package:flutter/material.dart';

import '../components/placeholder_section.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderSection(
      icon: Icons.assignment_outlined,
      title: 'Lamaran Saya',
      description: 'Riwayat dan status lamaranmu akan tampil di sini.',
      featureLabel: 'Dikerjakan di Fitur 6',
    );
  }
}