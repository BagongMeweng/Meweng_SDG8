import 'package:flutter/material.dart';

import '../components/auth_header.dart';
import '../components/password_field.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';
import '../utils/validators.dart';

/// Halaman Register (simulasi). Akun tidak benar-benar disimpan.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Tombol "Daftar": jika valid, tampilkan SnackBar sukses lalu kembali ke Login.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();

    // SnackBar milik ScaffoldMessenger sehingga tetap tampil di halaman Login
    // setelah halaman ini ditutup.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Akun "$username" berhasil dibuat. Silakan masuk.'),
      ),
    );

    // pop: menutup halaman Register dan kembali ke Login.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar otomatis menyediakan tombol kembali ke Login.
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: Responsive.pagePadding(context),
            child: ResponsiveCenter(
              maxWidth: Responsive.formMaxWidth,
              child: Column(
                children: [
                  // --- Header ---
                  const AuthHeader(
                    icon: Icons.person_add_outlined,
                    title: 'Buat Akun Meweng',
                    subtitle: 'Daftar untuk mulai mencari pekerjaan layak.',
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // --- Form dalam Card ---
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Field Username: minimal 3 karakter.
                            TextFormField(
                              controller: _usernameController,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: Validators.username,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Field Email: format email valid.
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: Validators.email,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Field Password: minimal 6 karakter, ada huruf dan angka.
                            PasswordField(
                              controller: _passwordController,
                              helperText: 'Minimal 6 karakter, huruf dan angka',
                              validator: Validators.registerPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            FilledButton(
                              onPressed: _submit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                              ),
                              child: const Text('Daftar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}