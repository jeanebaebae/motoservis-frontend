import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../dashboard/dashboard_page.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscured = true;

  void _openDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const DashboardPage()),
    );
  }

  void _openSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const SignUpPage()),
    );
  }

  void _openForgotPassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ForgotPasswordPage()));
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
          'Masuk',
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
                              'Masuk MotoServis',
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Masuk untuk memantau riwayat servis motor Anda dengan lebih mudah dan terorganisir.',
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
                                  hintText: 'Masukkan password',
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _openForgotPassword,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.secondary,
                                  textStyle: theme.textTheme.labelLarge,
                                  padding: const EdgeInsets.only(top: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Lupa Password?'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 60,
                              child: FilledButton.icon(
                                onPressed: _openDashboard,
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
                                icon: const Icon(Icons.login),
                                label: const Text('Masuk'),
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
                              'Belum punya akun? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: _openSignUp,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.secondary,
                                textStyle: theme.textTheme.labelLarge,
                                padding: const EdgeInsets.only(left: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Daftar Sekarang'),
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
