import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import '../components/job_card.dart';
import '../utils/app_theme.dart';
import '../utils/mock_data.dart';
import '../utils/models.dart';
import '../utils/responsive.dart';

/// Beranda (Fitur 3). Satu [CustomScrollView] berisi empat bagian:
/// 1. sapaan pengguna, 2. search bar yang berfungsi, 3. carousel rekomendasi
/// (statis, tidak terpengaruh pencarian), 4. grid responsif yang difilter
/// oleh kata kunci pencarian.
///
/// Jumlah kolom grid mengikuti lebar ruang yang tersedia (bukan lebar layar)
/// lewat [ResponsiveBuilder]: 1 kolom di ponsel, 2 di tablet, 3 di web/layar
/// lebar. Data berasal dari mock data, tidak ada backend.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Lebar maksimum konten agar kartu tidak melebar berlebihan di layar besar.
  static const double _maxContentWidth = 1100;

  /// Controller teks search bar. Dibuat saat deklarasi dan wajib di-dispose.
  final TextEditingController _searchController = TextEditingController();

  /// Kata kunci pencarian saat ini. Diperbarui setiap pengguna mengetik.
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  /// True jika judul, nama perusahaan, atau lokasi lowongan memuat [query]
  /// (huruf besar/kecil diabaikan). [query] sudah dalam huruf kecil.
  static bool _matchesQuery(Job job, String query) {
    return job.title.toLowerCase().contains(query) ||
        job.company.name.toLowerCase().contains(query) ||
        job.location.toLowerCase().contains(query);
  }

  /// Tinggi satu [JobCard]. Grid dan carousel butuh tinggi yang pasti, jadi
  /// dihitung dari susunan JobCard: padding (2 x md) + jarak antarbaris
  /// (xs + sm + xs) + empat baris teks (24 + 20 + 20 + 16 pada skala 1).
  /// Baris teks dikalikan skala font perangkat supaya tidak overflow saat
  /// pengguna memperbesar teks. Jika tata letak JobCard diubah, sesuaikan
  /// angka di sini.
  static double _jobCardHeight(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    const fixed = AppSpacing.md * 2 + AppSpacing.xs * 2 + AppSpacing.sm;
    return fixed + 80 * textScale + 4; // +4 sebagai cadangan pembulatan
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final isSearching = query.isNotEmpty;

    // Carousel: TIDAK membaca _searchQuery, jadi selalu tampil sama.
    final featuredJobs = mockRecommendedJobs;
    final featuredIds = featuredJobs.map((job) => job.id).toSet();

    // Grid: saat mencari, semua lowongan difilter oleh kata kunci.
    // Saat kolom pencarian kosong, tampilkan lowongan di luar carousel.
    final gridJobs = isSearching
        ? mockJobs.where((job) => _matchesQuery(job, query)).toList()
        : mockJobs.where((job) => !featuredIds.contains(job.id)).toList();

    final cardHeight = _jobCardHeight(context);

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        // LayoutBuilder kedua hanya untuk mengetahui lebar ruang yang tersedia,
        // dipakai memusatkan konten dan menghitung lebar kartu carousel.
        return LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.md;

            final basePadding = switch (screenSize) {
              ScreenSize.compact => AppSpacing.md,
              ScreenSize.medium => AppSpacing.lg,
              ScreenSize.expanded => AppSpacing.xl,
            };
            final columns = switch (screenSize) {
              ScreenSize.compact => 1,
              ScreenSize.medium => 2,
              ScreenSize.expanded => 3,
            };

            // Margin kiri-kanan: minimal basePadding, melebar di layar besar
            // sehingga konten tetap di tengah dengan lebar maksimum.
            final inset = math.max(
              basePadding,
              (constraints.maxWidth - _maxContentWidth) / 2,
            );
            final contentWidth = constraints.maxWidth - inset * 2;
            final columnWidth = (contentWidth - gap * (columns - 1)) / columns;

            // Ponsel: kartu dibuat 85% lebar supaya kartu berikutnya
            // mengintip dan pengguna tahu carousel bisa digeser.
            // Layar lebar: lebar kartu sama dengan kolom grid di bawahnya.
            final carouselItemWidth =
                columns == 1 ? columnWidth * 0.85 : columnWidth;

            return CustomScrollView(
              // Keyboard otomatis tertutup saat daftar digulir (ponsel).
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                // (1) Sapaan dan (2) search bar.
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(inset, AppSpacing.md, inset, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Greeting(),
                        const SizedBox(height: AppSpacing.md),
                        _SearchField(
                          controller: _searchController,
                          hasText: _searchQuery.isNotEmpty,
                          onChanged: _onSearchChanged,
                          onClear: _clearSearch,
                        ),
                      ],
                    ),
                  ),
                ),

                // (3) Carousel horizontal: rekomendasi (statis).
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    inset,
                    AppSpacing.lg,
                    inset,
                    AppSpacing.sm,
                  ),
                  sliver: const SliverToBoxAdapter(
                    child: _SectionTitle('Rekomendasi untukmu'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: cardHeight,
                    // Mouse dan trackpad ikut bisa menggeser carousel
                    // (di web, bawaan Flutter hanya mengizinkan sentuhan).
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                          PointerDeviceKind.stylus,
                        },
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: inset),
                        itemCount: featuredJobs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: gap),
                        itemBuilder: (context, index) => SizedBox(
                          width: carouselItemWidth,
                          // Navigasi ke detail lowongan dikerjakan di Fitur 5.
                          child: JobCard(job: featuredJobs[index]),
                        ),
                      ),
                    ),
                  ),
                ),

                // (4) Grid responsif: lowongan lainnya / hasil pencarian.
                if (isSearching || gridJobs.isNotEmpty) ...[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      inset,
                      AppSpacing.lg,
                      inset,
                      AppSpacing.sm,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _SectionTitle(
                        isSearching
                            ? 'Hasil pencarian (${gridJobs.length})'
                            : 'Lowongan lainnya',
                      ),
                    ),
                  ),
                  if (gridJobs.isEmpty)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: inset),
                      sliver: const SliverToBoxAdapter(child: _EmptyResult()),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: inset),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: gap,
                          mainAxisSpacing: gap,
                          mainAxisExtent: cardHeight,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => JobCard(job: gridJobs[index]),
                          childCount: gridJobs.length,
                        ),
                      ),
                    ),
                ],

                // Ruang kosong di akhir halaman.
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              ],
            );
          },
        );
      },
    );
  }
}

/// Sapaan "Halo, [nama]" beserta satu kalimat pengantar.
class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, ${mockUser.name}',
          style: textTheme.headlineSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Temukan pekerjaan layak yang cocok untukmu.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Search bar Material 3. Aktif: bisa diketik, tidak ada widget yang menutupi
/// (tanpa AbsorbPointer, readOnly, atau enabled: false). Tombol hapus (X)
/// muncul hanya saat kolom berisi teks.
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hasText,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SearchBar(
      controller: controller,
      hintText: 'Cari lowongan',
      leading: const Icon(Icons.search),
      trailing: [
        if (hasText)
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Hapus pencarian',
            onPressed: onClear,
          ),
      ],
      onChanged: onChanged,
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(
        colorScheme.surfaceContainerHigh,
      ),
    );
  }
}

/// Tampilan saat tidak ada lowongan yang cocok dengan kata kunci.
class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.sm),
          Text('Lowongan tidak ditemukan', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Coba kata kunci lain, misalnya kasir atau admin.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Judul bagian (hierarki: titleLarge, lebih menonjol dari isi kartu).
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }
}