import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/responsive.dart';

/// Isi halaman sementara untuk fitur yang belum dikerjakan.
/// Akan diganti saat fitur terkait selesai. [child] opsional untuk
/// menampilkan pratinjau di bawah keterangan.
class PlaceholderSection extends StatelessWidget {
  const PlaceholderSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.featureLabel,
    this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final String featureLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: Responsive.pagePadding(context),
      child: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.lg),
            CircleAvatar(
              radius: 36,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(icon, size: 36, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Chip(
              avatar: const Icon(Icons.construction, size: 18),
              label: Text(featureLabel),
            ),
            if (child != null) ...[
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: child),
            ],
          ],
        ),
      ),
    );
  }
}