
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