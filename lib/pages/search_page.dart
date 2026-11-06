import 'package:flutter/material.dart';

import '../components/placeholder_section.dart';

/// Cari Lowongan. Placeholder, dikerjakan di Fitur 4.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderSection(
      icon: Icons.search,
      title: 'Cari Lowongan',
      description: 'Pencarian dan filter lowongan akan tampil di sini.',
      featureLabel: 'Dikerjakan di Fitur 4',
    );
  }
}