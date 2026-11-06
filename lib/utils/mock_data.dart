import 'models.dart';

const Company _majuJaya = Company(id: 1, name: 'CV Maju Jaya', isVerified: true);
const Company _kopiTepian = Company(id: 2, name: 'Kopi Tepian', isVerified: true);
const Company _tokoBerkah = Company(id: 3, name: 'Toko Berkah', isVerified: true);
const Company _martSejahtera =
    Company(id: 4, name: 'Mart Sejahtera', isVerified: true);
const Company _rumahMakanSari =
    Company(id: 5, name: 'Rumah Makan Sari', isVerified: false);
const Company _binaCipta =
    Company(id: 6, name: 'PT Bina Cipta Mandiri', isVerified: true);
const Company _apotekSehat =
    Company(id: 7, name: 'Apotek Sehat Sentosa', isVerified: true);
const Company _klinikHarapan =
    Company(id: 8, name: 'Klinik Pratama Harapan', isVerified: true);
const Company _bengkelMajuMotor =
    Company(id: 9, name: 'Bengkel Maju Motor', isVerified: false);
const List<Job> mockJobs = [
  Job(
    id: 1,
    title: 'Staf Administrasi',
    company: _majuJaya,
    location: 'Medan Petisah',
    salaryMin: 4500000,
    salaryMax: 5500000,
    benefits: ['Transport', 'BPJS'],
    description: 'Mengelola arsip, surat masuk, dan jadwal kantor.',
    requiredSkills: ['Excel', 'Administrasi', 'Komunikasi'],
    matchScore: 92,
  ),
  Job(
    id: 2,
    title: 'Barista',
    company: _kopiTepian,
    location: 'Medan Baru',
    salaryMin: 3200000,
    salaryMax: 4000000,
    benefits: ['Makan siang', 'BPJS Kesehatan'],
    description: 'Menyiapkan minuman, menjaga kebersihan bar, dan melayani tamu.',
    requiredSkills: ['Komunikasi', 'Pelayanan'],
    matchScore: 74,
  ),
  Job(
    id: 3,
    title: 'Kasir Toko',
    company: _tokoBerkah,
    location: 'Medan Johor',
    salaryMin: 3000000,
    salaryMax: 3600000,
    benefits: ['Transport', 'THR'],
    description: 'Melayani pembayaran, mencatat transaksi, dan merapikan kasir.',
    requiredSkills: ['Kasir', 'Excel'],
    matchScore: 88,
  ),
  Job(
    id: 4,
    title: 'Kasir Minimarket',
    company: _martSejahtera,
    location: 'Medan Sunggal',
    salaryMin: 3400000,
    salaryMax: 3900000,
    benefits: ['BPJS', 'Bonus penjualan'],
    description: 'Melayani pelanggan di kasir dan membantu penataan barang.',
    requiredSkills: ['Kasir', 'Komunikasi'],
    matchScore: 81,
  ),
  Job(
    id: 5,
    title: 'Kasir Restoran',
    company: _rumahMakanSari,
    location: 'Medan Kota',
    salaryMin: 3200000,
    salaryMax: 3800000,
    benefits: ['Makan gratis'],
    description: 'Mencatat pesanan dan menerima pembayaran pelanggan restoran.',
    requiredSkills: ['Kasir', 'Komunikasi'],
    matchScore: 65,
  ),
  Job(
    id: 6,
    title: 'Staf Gudang',
    company: _majuJaya,
    location: 'Medan Deli',
    salaryMin: 3800000,
    salaryMax: 4500000,
    benefits: ['BPJS', 'Tunjangan kehadiran'],
    description: 'Mencatat barang masuk dan keluar serta menjaga kerapian gudang.',
    requiredSkills: ['Administrasi', 'Excel'],
    matchScore: 60,
  ),
  Job(
    id: 7,
    title: 'Admin Penjualan Online',
    company: _tokoBerkah,
    location: 'Medan Johor',
    salaryMin: 3500000,
    salaryMax: 4200000,
    benefits: ['Transport', 'Bonus target'],
    description: 'Membalas pesan pelanggan dan merekap pesanan dari marketplace.',
    requiredSkills: ['Excel', 'Komunikasi'],
    matchScore: 85,
  ),
  Job(
    id: 8,
    title: 'Customer Service',
    company: _binaCipta,
    location: 'Medan Petisah',
    salaryMin: 4000000,
    salaryMax: 5000000,
    benefits: ['BPJS', 'Asuransi', 'Pelatihan'],
    description: 'Menangani keluhan pelanggan lewat telepon dan pesan singkat.',
    requiredSkills: ['Komunikasi', 'Pelayanan'],
    matchScore: 79,
  ),
  Job(
    id: 9,
    title: 'Staf Keuangan Junior',
    company: _binaCipta,
    location: 'Medan Petisah',
    salaryMin: 4200000,
    salaryMax: 5200000,
    benefits: ['BPJS', 'Bonus tahunan'],
    description:
        'Mencatat transaksi harian, menyusun rekap kas, dan membantu laporan bulanan.',
    requiredSkills: ['Excel', 'Akuntansi'],
    matchScore: 90,
  ),
  Job(
    id: 10,
    title: 'Kasir Apotek',
    company: _apotekSehat,
    location: 'Medan Selayang',
    salaryMin: 3300000,
    salaryMax: 3900000,
    benefits: ['BPJS', 'Seragam'],
    description:
        'Melayani pembayaran obat bebas, mencatat penjualan harian, dan merapikan etalase.',
    requiredSkills: ['Kasir', 'Komunikasi'],
    matchScore: 83,
  ),
  Job(
    id: 11,
    title: 'Staf Pembukuan Toko',
    company: _tokoBerkah,
    location: 'Medan Johor',
    salaryMin: 3600000,
    salaryMax: 4300000,
    benefits: ['Transport', 'THR'],
    description:
        'Mencatat pemasukan dan pengeluaran toko serta menyusun rekap mingguan.',
    requiredSkills: ['Excel', 'Administrasi'],
    matchScore: 87,
  ),
  Job(
    id: 12,
    title: 'Resepsionis Klinik',
    company: _klinikHarapan,
    location: 'Medan Tuntungan',
    salaryMin: 3800000,
    salaryMax: 4600000,
    benefits: ['BPJS', 'Asuransi'],
    description:
        'Menerima pasien, mengatur jadwal kunjungan, dan mengelola berkas pendaftaran.',
    requiredSkills: ['Komunikasi', 'Administrasi'],
    matchScore: 77,
  ),
  Job(
    id: 13,
    title: 'Kasir Kafe',
    company: _kopiTepian,
    location: 'Medan Baru',
    salaryMin: 3100000,
    salaryMax: 3700000,
    benefits: ['Makan siang', 'Tip'],
    description:
        'Mengoperasikan mesin kasir, mencatat pesanan, dan menutup kas harian.',
    requiredSkills: ['Kasir', 'Komunikasi'],
    matchScore: 86,
  ),
  Job(
    id: 14,
    title: 'Teknisi Bengkel Pemula',
    company: _bengkelMajuMotor,
    location: 'Medan Amplas',
    salaryMin: 2800000,
    salaryMax: 3500000,
    benefits: ['Makan siang'],
    description:
        'Membantu servis ringan sepeda motor dan merapikan peralatan bengkel.',
    requiredSkills: ['Mekanik', 'Ketelitian'],
    matchScore: 55,
  ),
];

/// Rekomendasi untuk carousel Beranda: 6 lowongan dengan skor kecocokan
/// tertinggi. Daftar ini tidak dipengaruhi pencarian.
final List<Job> mockRecommendedJobs = (List<Job>.of(mockJobs)
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore)))
    .take(6)
    .toList();

const UserProfile mockUser = UserProfile(
  name: 'Dina Pratama',
  headline: 'Pencari kerja',
  email: 'dina.pratama@example.com',
  education: 'SMK Akuntansi',
  skills: ['Excel', 'Kasir', 'Komunikasi'],
  completeness: 0.7,
);