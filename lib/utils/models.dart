import 'formatters.dart';

/// Perusahaan pemberi kerja. Status verifikasi adalah inti fitur "kerja layak".
class Company {
  const Company({
    required this.id,
    required this.name,
    required this.isVerified,
  });

  final int id;
  final String name;
  final bool isVerified;

  /// Inisial untuk avatar, contoh: "CV Maju Jaya" menjadi "MJ".
  /// Awalan badan usaha (CV, PT, UD) dilewati.
  String get initials {
    const prefixes = {'cv', 'pt', 'ud'};
    final words = name
        .split(' ')
        .where((w) => w.isNotEmpty && !prefixes.contains(w.toLowerCase()))
        .toList();
    if (words.isEmpty) return '?';
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }
}

/// Lowongan pekerjaan. Gaji disimpan dalam rupiah per bulan.
class Job {
  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salaryMin,
    required this.salaryMax,
    required this.benefits,
    required this.description,
    required this.requiredSkills,
    required this.matchScore,
  });

  final int id;
  final String title;
  final Company company;
  final String location;
  final int salaryMin;
  final int salaryMax;
  final List<String> benefits;
  final String description;
  final List<String> requiredSkills;

  /// Skor kecocokan 0-100 (nilai tetap dari mock data).
  final int matchScore;

  String get salaryLabel => formatSalaryRange(salaryMin, salaryMax);
  bool get isVerified => company.isVerified;
}

/// Profil pencari kerja yang sedang login (data contoh).
class UserProfile {
  const UserProfile({
    required this.name,
    required this.headline,
    required this.email,
    required this.education,
    required this.skills,
    required this.completeness,
  });

  final String name;
  final String headline;
  final String email;
  final String education;
  final List<String> skills;

  /// Kelengkapan profil dari 0.0 sampai 1.0.
  final double completeness;

  String get initials {
    final words = name.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }
}