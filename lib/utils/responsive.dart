import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Kelas ukuran layar mengikuti window size class Material 3.
enum ScreenSize {
  /// Lebar < 600dp (ponsel potret).
  compact,

  medium,

  /// Lebar >= 840dp (tablet besar, desktop).
  expanded,
}

/// Helper responsif global. Semua halaman dan komponen memakai kelas ini
/// agar aturan breakpoint hanya ada di satu tempat.
class Responsive {
  Responsive._();

  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  /// Lebar maksimum konten supaya teks tidak terlalu melebar di layar besar.
  static const double contentMaxWidth = 840;

  /// Lebar maksimum untuk halaman berisi form (login, register, dll.)
  /// agar kolom isian tidak terlalu lebar di tablet.
  static const double formMaxWidth = 480;

  /// Menentukan kelas ukuran dari sebuah lebar (dipakai bersama LayoutBuilder).
  static ScreenSize fromWidth(double width) {
    if (width < mediumBreakpoint) return ScreenSize.compact;
    if (width < expandedBreakpoint) return ScreenSize.medium;
    return ScreenSize.expanded;
  }

  /// Kelas ukuran berdasarkan lebar layar (MediaQuery).
  static ScreenSize of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }

  /// True jika perangkat sedang landscape.
  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  /// Memilih nilai sesuai ukuran layar. Jika [medium] atau [expanded] tidak
  /// diisi, dipakai nilai ukuran di bawahnya.
  static T value<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
  }) {
    return switch (of(context)) {
      ScreenSize.compact => compact,
      ScreenSize.medium => medium ?? compact,
      ScreenSize.expanded => expanded ?? medium ?? compact,
    };
  }

  /// Padding halaman yang menyesuaikan ukuran layar.
  static EdgeInsets pagePadding(BuildContext context) {
    final horizontal = value<double>(
      context,
      compact: AppSpacing.md,
      medium: AppSpacing.lg,
      expanded: AppSpacing.xl,
    );
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: AppSpacing.md);
  }

  /// Jumlah kolom grid yang disarankan (dipakai di fitur pencarian nanti).
  static int gridColumns(BuildContext context) {
    return value<int>(context, compact: 1, medium: 2, expanded: 3);
  }
}

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  ScreenSize screenSize,
);

/// Membangun widget berdasarkan constraint (lebar yang tersedia) dari parent,
/// bukan lebar seluruh layar. Cocok untuk layout yang berubah mengikuti ruang.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, Responsive.fromWidth(constraints.maxWidth));
      },
    );
  }
}

/// Membatasi lebar konten dan menempatkannya di tengah pada layar lebar.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = Responsive.contentMaxWidth,
  });

  final Widget child;

  /// Lebar maksimum konten. Bawaan: [Responsive.contentMaxWidth].
  /// Halaman form memakai [Responsive.formMaxWidth].
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}