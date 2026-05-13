import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  void _openLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          tooltip: 'Kembali',
        ),
        titleSpacing: 0,
        title: Text(
          'Buat Akun Baru',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        elevation: 2,
        shape: const Border(
          bottom: BorderSide(color: AppColors.surfaceVariant),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 480,
                    minHeight: constraints.maxHeight - 64,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar MotoServis',
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bergabunglah untuk memantau riwayat servis motor Anda dengan lebih mudah dan terorganisir.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _LabeledField(
                              label: 'Nama Lengkap',
                              child: TextFormField(
                                decoration: _inputDecoration(
                                  hintText: 'Masukkan nama...',
                                  prefixIcon: Icons.person_outline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'Email',
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: _inputDecoration(
                                  hintText: 'contoh@email.com',
                                  prefixIcon: Icons.mail_outline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'Password',
                              child: TextFormField(
                                obscureText: _isPasswordObscured,
                                decoration: _inputDecoration(
                                  hintText: 'Min. 8 karakter',
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordObscured =
                                            !_isPasswordObscured;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.outlineVariant,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'Konfirmasi Password',
                              child: TextFormField(
                                obscureText: _isConfirmPasswordObscured,
                                decoration: _inputDecoration(
                                  hintText: 'Ulangi password',
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordObscured =
                                            !_isConfirmPasswordObscured;
                                      });
                                    },
                                    icon: Icon(
                                      _isConfirmPasswordObscured
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.outlineVariant,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 60,
                              child: FilledButton.icon(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  textStyle: theme.textTheme.headlineSmall
                                      ?.copyWith(color: AppColors.onPrimary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.app_registration),
                                label: const Text('Daftar'),
                                iconAlignment: IconAlignment.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: _openLogin,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.secondary,
                                textStyle: theme.textTheme.labelLarge,
                                padding: const EdgeInsets.only(left: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Masuk'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
      ),
      prefixIcon: Icon(prefixIcon, color: AppColors.outlineVariant, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _fieldBorder(AppColors.outlineVariant),
      enabledBorder: _fieldBorder(AppColors.outlineVariant),
      focusedBorder: _fieldBorder(AppColors.primary),
    );
  }

  OutlineInputBorder _fieldBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
