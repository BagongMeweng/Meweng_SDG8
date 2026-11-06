import 'package:flutter/material.dart';

import '../components/auth_header.dart';
import '../components/password_field.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';
import '../utils/validators.dart';
import 'forgot_password_page.dart';
import 'main_page.dart';
import 'register_page.dart';
import '../services/auth_services.dart';


/// Halaman Login (simulasi). Tidak ada backend: yang diuji hanya validasi
/// form dan perpindahan halaman.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // SATU FUNGSI UNTUK SEMUA: Validasi, Simpan State, lalu Navigasi
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // 1. Simpan status login ke memori perangkat
      await AuthService.setLoggedIn(true);

      // 2. Cek apakah widget masih ada di tree sebelum navigasi (mencegah error)
      if (!mounted) return;

      // 3. Pindah ke MainPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    }
  }

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
    );
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: Responsive.pagePadding(context),
            child: ResponsiveCenter(
              maxWidth: Responsive.formMaxWidth,
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Masuk ke Meweng',
                    subtitle: 'Temukan pekerjaan layak untuk masa depanmu.',
                  ),
                  const SizedBox(height: AppSpacing.lg),

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

                            PasswordField(
                              controller: _passwordController,
                              validator: Validators.loginPassword,
                              textInputAction: TextInputAction.done,
                              // Gunakan _submit() yang baru
                              onFieldSubmitted: (_) => _submit(),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _openForgotPassword,
                                child: const Text('Lupa Password?'),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),

                            FilledButton(
                              // Gunakan _submit() yang baru
                              onPressed: _submit, 
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                              ),
                              child: const Text('Masuk'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  TextButton(
                    onPressed: _openRegister,
                    child: const Text('Belum punya akun? Daftar'),
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