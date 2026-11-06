import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Badge status verifikasi perusahaan (inti fitur pekerjaan layak).
/// - [compact] true: hanya ikon bulat (untuk kartu lowongan).
/// - [compact] false: ikon dan teks (untuk halaman detail nanti).
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({
    super.key,
    required this.isVerified,
    this.compact = false,
  });

  final bool isVerified;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color background = isVerified
        ? (isDark
            ? AppColors.verifiedBackgroundDark
            : AppColors.verifiedBackgroundLight)
        : colorScheme.surfaceContainerHighest;
    final Color foreground = isVerified
        ? (isDark
            ? AppColors.verifiedForegroundDark
            : AppColors.verifiedForegroundLight)
        : colorScheme.onSurfaceVariant;
    final IconData icon = isVerified ? Icons.verified : Icons.info_outline;
    final String label = isVerified ? 'Terverifikasi' : 'Belum terverifikasi';

    if (compact) {
      return Tooltip(
        message: label,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: foreground),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}