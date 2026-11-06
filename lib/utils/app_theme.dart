import 'package:flutter/material.dart';

/// Jarak standar berbasis grid 8dp. Dipakai di seluruh aplikasi supaya
/// spacing konsisten (prinsip Material Design: spacing & hierarchy).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Radius sudut standar untuk kartu, tombol, dan badge.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;
}

/// Warna khusus aplikasi di luar ColorScheme bawaan Material 3.
class AppColors {
  AppColors._();

  /// Warna dasar (seed). Seluruh palet Material 3 diturunkan dari warna ini.
  static const Color seed = Color(0xFFA21942);

  /// Warna status "Terverifikasi" (hijau), versi tema terang dan gelap.
  static const Color verifiedBackgroundLight = Color(0xFFDDF3E1);
  static const Color verifiedForegroundLight = Color(0xFF1B5E2C);
  static const Color verifiedBackgroundDark = Color(0xFF1F3D27);
  static const Color verifiedForegroundDark = Color(0xFF8FD99F);
}

/// Tema Material 3 untuk aplikasi Meweng (terang dan gelap).
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    // Material 3: seluruh warna (primary, surface, dll.) dibuat otomatis dari seed.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);
    final textTheme = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      // Typography: judul dibuat sedikit lebih tebal agar hierarki
      // (judul > subjudul > isi) lebih jelas terbaca.
      textTheme: textTheme.copyWith(
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        scrolledUnderElevation: 0,
      ),
    );
  }
}