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
];

const UserProfile mockUser = UserProfile(
  name: 'Dina Pratama',
  headline: 'Pencari kerja',
  email: 'dina.pratama@example.com',
  education: 'SMK Akuntansi',
  skills: ['Excel', 'Kasir', 'Komunikasi'],
  completeness: 0.7,
);