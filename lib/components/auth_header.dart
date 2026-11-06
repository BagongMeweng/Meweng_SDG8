import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Bagian kepala halaman autentikasi: ikon besar, judul, dan sub-judul.
/// Dipakai di Login, Register, dan Lupa Password agar tampilannya seragam.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.work_outline_rounded,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Ikon utama (ukuran 80) sebagai identitas visual halaman.
        Icon(icon, size: 80, color: colorScheme.primary),
        const SizedBox(height: AppSpacing.md),
        // Hierarki: judul tebal (headlineSmall) di atas sub-judul (bodyMedium).
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}