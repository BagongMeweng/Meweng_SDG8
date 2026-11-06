import 'package:flutter/material.dart';

import '../components/job_card.dart';
import '../components/placeholder_section.dart';
import '../utils/app_theme.dart';
import '../utils/mock_data.dart';

/// Beranda. Masih placeholder (dikerjakan di Fitur 3), tetapi sudah menampilkan
/// 3 lowongan dari mock data untuk membuktikan JobCard dan data contoh berfungsi.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PlaceholderSection(
      icon: Icons.home_outlined,
      title: 'Beranda',
      description: 'Rekomendasi lowongan untukmu akan tampil di sini.',
      featureLabel: 'Dikerjakan di Fitur 3',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pratinjau data mock', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final job in mockJobs.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: JobCard(job: job),
            ),
        ],
      ),
    );
  }
}