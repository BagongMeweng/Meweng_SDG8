import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import '../components/job_card.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/mock_data.dart';
import '../utils/models.dart';
import '../utils/responsive.dart';

/// Cari Lowongan (Fitur 4). Satu [CustomScrollView] berisi:
/// 1. search bar, 2. filter (slider rentang Gaji, chip Terverifikasi, chip
/// Lokasi), 3. teks jumlah hasil, 4. daftar lowongan: List di ponsel,
/// Grid 2-3 kolom di layar lebar.
///
/// Kata kunci dan semua filter digabung (AND). Data dari mock data.
///
/// Filter gaji memakai [RangeSlider] dengan kenaikan Rp100.000. Lowongan
/// cocok jika rentang gajinya (salaryMin..salaryMax) beririsan dengan rentang
/// yang dipilih. Menggeser kedua titik ke angka yang sama berarti gaji pasti:
/// lowongan cocok jika rentang gajinya memuat angka itu.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  /// Lebar maksimum konten agar kartu tidak melebar berlebihan di layar besar.
  static const double _maxContentWidth = 1100;

  /// Lokasi unik dari mock data, diurutkan abjad (dipakai untuk chip Lokasi).
  static final List<String> _locations =
      mockJobs.map((job) => job.location).toSet().toList()..sort();

  /// Kenaikan slider gaji: Rp100.000.
  static const int _salaryStep = 100000;

  /// Label chip filter Status.
  static const String _verifiedLabel = 'Terverifikasi';

  /// Batas slider gaji diturunkan dari data lowongan, dibulatkan ke kelipatan
  /// [_salaryStep] (batas bawah ke bawah, batas atas ke atas). Jika mock data
  /// (atau nanti data dari server) berubah, slider ikut menyesuaikan.
  static final RangeValues _salaryBounds = () {
    final lowest = mockJobs.map((job) => job.salaryMin).reduce(math.min);
    final highest = mockJobs.map((job) => job.salaryMax).reduce(math.max);
    final floor = (lowest ~/ _salaryStep) * _salaryStep;
    final ceiling = ((highest + _salaryStep - 1) ~/ _salaryStep) * _salaryStep;
    return RangeValues(floor.toDouble(), ceiling.toDouble());
  }();

  /// Controller teks search bar. Dibuat saat deklarasi dan wajib di-dispose.
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  /// Rentang gaji terpilih. Sama dengan [_salaryBounds] berarti tanpa filter.
  RangeValues _salaryRange = _salaryBounds;

  /// True jika hanya menampilkan lowongan dari perusahaan terverifikasi.
  bool _verifiedOnly = false;

  String? _locationFilter;

  bool get _isSalaryFiltered => _salaryRange != _salaryBounds;

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

  void _onSalaryChanged(RangeValues values) {
    // Bulatkan ke kelipatan Rp100.000 supaya nilai selalu bersih
    // (menghindari selisih pecahan dari perhitungan double).
    double snap(double value) =>
        (value / _salaryStep).round() * _salaryStep.toDouble();
    setState(() {
      _salaryRange = RangeValues(snap(values.start), snap(values.end));
    });
  }

  void _resetFilters() {
    setState(() {
      _salaryRange = _salaryBounds;
      _verifiedOnly = false;
      _locationFilter = null;
    });
  }

  void _resetAll() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _salaryRange = _salaryBounds;
      _verifiedOnly = false;
      _locationFilter = null;
    });
  }

  /// True jika rentang gaji lowongan beririsan dengan rentang terpilih.
  /// Jika kedua ujung slider sama (gaji pasti), berarti rentang gaji
  /// lowongan memuat angka tersebut.
  bool _matchesSalary(Job job) {
    return job.salaryMax >= _salaryRange.start &&
        job.salaryMin <= _salaryRange.end;
  }

  /// True jika judul, perusahaan, lokasi, atau salah satu keahlian lowongan
  /// memuat [query] (huruf besar/kecil diabaikan). [query] sudah huruf kecil.
  static bool _matchesQuery(Job job, String query) {
    return job.title.toLowerCase().contains(query) ||
        job.company.name.toLowerCase().contains(query) ||
        job.location.toLowerCase().contains(query) ||
        job.requiredSkills.any((skill) => skill.toLowerCase().contains(query));
  }

  /// Tinggi satu [JobCard] (rumus yang sama dengan di home_page.dart).
  /// Grid butuh tinggi yang pasti, jadi dihitung dari susunan JobCard:
  /// padding (2 x md) + jarak antarbaris (xs + sm + xs) + empat baris teks
  /// (24 + 20 + 20 + 16 pada skala 1) dikali skala font perangkat.
  /// Jika tata letak JobCard diubah, sesuaikan angka di sini.
  static double _jobCardHeight(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    const fixed = AppSpacing.md * 2 + AppSpacing.xs * 2 + AppSpacing.sm;
    return fixed + 80 * textScale + 4; // +4 sebagai cadangan pembulatan
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final query = _searchQuery.trim().toLowerCase();
    final location = _locationFilter;
    final salaryFiltered = _isSalaryFiltered;
    final hasActiveFilter =
        salaryFiltered || _verifiedOnly || location != null;

    // Kata kunci + gaji + terverifikasi + lokasi, semuanya harus cocok.
    final results = mockJobs.where((job) {
      if (query.isNotEmpty && !_matchesQuery(job, query)) return false;
      if (salaryFiltered && !_matchesSalary(job)) return false;
      if (_verifiedOnly && !job.isVerified) return false;
      if (location != null && job.location != location) return false;
      return true;
    }).toList();

    final cardHeight = _jobCardHeight(context);

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        // LayoutBuilder kedua hanya untuk mengetahui lebar ruang yang tersedia,
        // dipakai memusatkan konten pada layar lebar.
        return LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.md;

            final isList = screenSize == ScreenSize.compact;
            final columns = screenSize == ScreenSize.expanded ? 3 : 2;

            final basePadding = switch (screenSize) {
              ScreenSize.compact => AppSpacing.md,
              ScreenSize.medium => AppSpacing.lg,
              ScreenSize.expanded => AppSpacing.xl,
            };

            // Margin kiri-kanan: minimal basePadding, melebar di layar besar
            // sehingga konten tetap di tengah dengan lebar maksimum.
            final inset = math.max(
              basePadding,
              (constraints.maxWidth - _maxContentWidth) / 2,
            );

            final salaryFilter = _SalaryRangeFilter(
              bounds: _salaryBounds,
              step: _salaryStep,
              values: _salaryRange,
              onChanged: _onSalaryChanged,
            );

            // [groupInset] 0 dipakai saat berada di dalam Row (layar lebar),
            // karena Row sudah diberi margin halaman.
            Widget statusFilter(double groupInset) => _FilterGroup<String>(
                  title: 'Status',
                  options: const [_verifiedLabel],
                  selected: _verifiedOnly ? _verifiedLabel : null,
                  labelOf: (option) => option,
                  onChanged: (value) {
                    setState(() => _verifiedOnly = value != null);
                  },
                  inset: groupInset,
                  wrap: !isList,
                );

            return CustomScrollView(
              // Keyboard otomatis tertutup saat daftar digulir (ponsel).
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                // (1) Search bar.
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(inset, AppSpacing.md, inset, 0),
                  sliver: SliverToBoxAdapter(
                    child: _SearchField(
                      controller: _searchController,
                      hasText: _searchQuery.isNotEmpty,
                      onChanged: _onSearchChanged,
                      onClear: _clearSearch,
                    ),
                  ),
                ),

                // (2) Filter. Ponsel: tersusun ke bawah, baris chip bisa
                // digeser. Tablet/PC: slider gaji dan filter Status
                // bersebelahan, chip dibungkus (Wrap).
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isList) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: inset),
                            child: salaryFilter,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          statusFilter(inset),
                        ] else
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: inset),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: salaryFilter),
                                const SizedBox(width: AppSpacing.xl),
                                Expanded(flex: 2, child: statusFilter(0)),
                              ],
                            ),
                          ),
                        const SizedBox(height: AppSpacing.sm),
                        _FilterGroup<String>(
                          title: 'Lokasi',
                          options: _locations,
                          selected: location,
                          labelOf: (option) => option,
                          onChanged: (value) {
                            setState(() => _locationFilter = value);
                          },
                          inset: inset,
                          wrap: !isList,
                        ),
                      ],
                    ),
                  ),
                ),

                // (3) Jumlah hasil, plus tombol reset saat ada filter aktif.
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    inset,
                    AppSpacing.md,
                    inset,
                    AppSpacing.sm,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            liveRegion: true,
                            child: Text(
                              '${results.length} lowongan ditemukan',
                              style: textTheme.titleSmall,
                            ),
                          ),
                        ),
                        if (hasActiveFilter)
                          TextButton.icon(
                            onPressed: _resetFilters,
                            icon: const Icon(Icons.restart_alt, size: 18),
                            label: const Text('Reset filter'),
                          ),
                      ],
                    ),
                  ),
                ),

                // (4) Daftar hasil: List di ponsel, Grid di layar lebar.
                if (results.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: inset),
                    sliver: SliverToBoxAdapter(
                      child: _EmptyResult(onReset: _resetAll),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: inset),
                    sliver: isList
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      index == results.length - 1 ? 0 : gap,
                                ),
                                // Navigasi ke detail dikerjakan di Fitur 5.
                                child: JobCard(job: results[index]),
                              ),
                              childCount: results.length,
                            ),
                          )
                        : SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: gap,
                              mainAxisSpacing: gap,
                              mainAxisExtent: cardHeight,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => JobCard(job: results[index]),
                              childCount: results.length,
                            ),
                          ),
                  ),

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

/// Search bar Material 3 dengan tombol hapus (X) yang muncul saat ada teks.
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
      hintText: 'Cari posisi, perusahaan, atau keahlian',
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

/// Filter gaji berupa [RangeSlider] dengan kenaikan [step] (Rp100.000).
/// Menggeser kedua titik ke angka yang sama memfilter gaji pasti.
///
/// Lebar slider mengikuti ruang dari parent, jadi di ponsel memenuhi lebar
/// layar dan di tablet/PC mengikuti kolomnya di halaman pencarian.
class _SalaryRangeFilter extends StatelessWidget {
  const _SalaryRangeFilter({
    required this.bounds,
    required this.step,
    required this.values,
    required this.onChanged,
  });

  /// Batas bawah dan atas slider (rupiah, kelipatan [step]).
  final RangeValues bounds;
  final int step;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final start = values.start.round();
    final end = values.end.round();
    final isFullRange = values == bounds;
    final divisions = math.max(1, ((bounds.end - bounds.start) / step).round());

    final captionStyle = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dan nilai terpilih. Wrap supaya tidak overflow di layar
        // sempit atau saat teks diperbesar.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            Text(
              'Gaji per bulan',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Semantics(
              liveRegion: true,
              child: Text(
                isFullRange
                    ? 'Semua gaji'
                    : formatSalarySelection(start, end),
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        // Tanda titik dimatikan (radius 0) supaya tetap rapi walaupun
        // rentang gaji melebar dan jumlah langkahnya jadi banyak.
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            rangeTickMarkShape: const RoundRangeSliderTickMarkShape(
              tickMarkRadius: 0,
            ),
          ),
          child: RangeSlider(
            values: values,
            min: bounds.start,
            max: bounds.end,
            divisions: divisions,
            labels: RangeLabels(
              formatSalaryValue(start),
              formatSalaryValue(end),
            ),
            semanticFormatterCallback: (value) =>
                formatSalaryValue(value.round()),
            onChanged: onChanged,
          ),
        ),
        // Batas slider; padding menyejajarkan teks dengan ujung track.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatSalaryValue(bounds.start.round()), style: captionStyle),
              Text(formatSalaryValue(bounds.end.round()), style: captionStyle),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Geser kedua titik ke angka yang sama untuk gaji pasti.',
          style: captionStyle,
        ),
      ],
    );
  }
}

/// Satu kategori filter: judul kecil di atas barisan [FilterChip].
/// Pilihan tunggal: menekan chip yang sedang aktif akan membatalkannya
/// ([onChanged] dipanggil dengan null).
///
/// [wrap] true: chip dibungkus ke baris berikutnya (layar lebar).
/// [wrap] false: satu baris yang bisa digeser (ponsel). [inset] adalah margin
/// halaman, dipakai supaya baris yang digeser menyentuh tepi layar.
class _FilterGroup<T> extends StatelessWidget {
  const _FilterGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    required this.inset,
    required this.wrap,
  });

  final String title;
  final List<T> options;
  final T? selected;
  final String Function(T option) labelOf;
  final ValueChanged<T?> onChanged;
  final double inset;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final chips = <Widget>[
      for (final option in options)
        FilterChip(
          label: Text(labelOf(option)),
          selected: option == selected,
          onSelected: (isSelected) => onChanged(isSelected ? option : null),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: inset),
          child: Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (wrap)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: inset),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: chips,
            ),
          )
        else
          // Mouse dan trackpad ikut bisa menggeser baris chip
          // (di web, bawaan Flutter hanya mengizinkan sentuhan).
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,
              },
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: inset),
              child: Row(
                children: [
                  for (var i = 0; i < chips.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.sm),
                    chips[i],
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Tampilan saat tidak ada lowongan yang cocok, dengan tombol reset.
class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.onReset});

  final VoidCallback onReset;

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
            'Coba kata kunci lain atau longgarkan filter yang aktif.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: onReset,
            child: const Text('Reset pencarian'),
          ),
        ],
      ),
    );
  }
}