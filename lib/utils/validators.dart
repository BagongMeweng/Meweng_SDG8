/// Kumpulan fungsi validasi form (simulasi, tanpa backend).
///
/// Setiap fungsi mengembalikan pesan error (String) jika isian tidak valid,
/// atau null jika valid. Bentuk ini sesuai dengan parameter `validator`
/// milik `TextFormField`.
class Validators {
  Validators._();

  /// Email: tidak boleh kosong dan harus berformat email.
  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email tidak boleh kosong';

    // Pola sederhana: nama@domain.tld
    final emailPattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    if (!emailPattern.hasMatch(text)) return 'Format email tidak valid';

    return null;
  }

  /// Password untuk login: tidak boleh kosong, minimal 6 karakter.
  static String? loginPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password tidak boleh kosong';
    if (text.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  /// Username untuk registrasi: tidak boleh kosong, minimal 3 karakter.
  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Username tidak boleh kosong';
    if (text.length < 3) return 'Username minimal 3 karakter';
    return null;
  }

  /// Password untuk registrasi: minimal 6 karakter dan harus
  /// mengandung huruf sekaligus angka.
  static String? registerPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password tidak boleh kosong';
    if (text.length < 6) return 'Password minimal 6 karakter';

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(text);
    final hasDigit = RegExp(r'\d').hasMatch(text);
    if (!hasLetter || !hasDigit) {
      return 'Password harus mengandung huruf dan angka';
    }
    return null;
  }
}