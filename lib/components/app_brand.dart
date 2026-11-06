import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Logo teks Meweng: kotak berwarna dengan huruf "M" dan nama aplikasi.
/// Dipakai di AppBar Beranda dan header Drawer.
class AppBrand extends StatelessWidget {
  const AppBrand({super.key, this.size = 32});

  /// Panjang sisi kotak logo.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            'M',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('Meweng', style: textTheme.titleLarge),
      ],
    );
  }
}