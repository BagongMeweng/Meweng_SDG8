String formatSalaryRange(int min, int max) {
  return 'Rp${_toJuta(min)}–${_toJuta(max)} jt';
}

String _toJuta(int rupiah) {
  final juta = rupiah / 1000000;
  final isWhole = juta == juta.roundToDouble();
  final text = isWhole ? juta.toStringAsFixed(0) : juta.toStringAsFixed(1);
  // Format Indonesia memakai koma sebagai pemisah desimal.
  return text.replaceAll('.', ',');
}

/// Satu nilai gaji, contoh: 3200000 menjadi "Rp3,2 jt".
String formatSalaryValue(int rupiah) {
  return 'Rp${_toJuta(rupiah)} jt';
}

/// Label pilihan filter gaji. Jika batas bawah dan atas sama (gaji pasti),
/// hanya satu angka yang ditampilkan: "Rp3,2 jt". Selain itu: "Rp3,2–4,5 jt".
String formatSalarySelection(int min, int max) {
  return min == max ? formatSalaryValue(min) : formatSalaryRange(min, max);
}