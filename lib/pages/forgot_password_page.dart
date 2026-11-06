import 'package:flutter/material.dart';

import '../components/auth_header.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';
import '../utils/validators.dart';

/// Halaman Lupa Password (simulasi). Tidak ada email yang benar-benar dikirim.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Tombol "Kirim Link Reset": validasi, tampilkan dialog konfirmasi,
  /// lalu kembali ke halaman Login.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    // Dialog konfirmasi (simulasi). await: menunggu dialog ditutup.
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.mark_email_read_outlined),
        title: const Text('Link reset terkirim'),
        content: Text(
          'Kami telah mengirim link untuk mengatur ulang password ke $email. '
          '(Ini hanya simulasi.)',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Kembali ke Login'),
          ),
        ],
      ),
    );

    // Setelah jeda await, pastikan halaman ini masih aktif sebelum dipakai.
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
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
                    icon: Icons.lock_reset_rounded,
                    title: 'Lupa Password?',
                    subtitle:
                        'Masukkan email akunmu, kami kirim link untuk mengatur ulang password.',
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
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: Validators.email,
                              onFieldSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            FilledButton(
                              onPressed: _submit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                              ),
                              child: const Text('Kirim Link Reset'),
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