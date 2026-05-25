import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login_page.dart';
import '../auth/sign_up_page.dart';
import '../core/theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _heroImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCVCg1r0yIsBiH781LV70_rRSdC5Ng2ngV0uF_GBelX6XV1YrrCri6DpOBv8tYlSdoUyB5okDo8wH6nl4kDOcjiDh8EXI2e1m2L6w0sb7TCoXYhTqEGljZxrOsZHzOeRdKfoiP_RHjEDBRTv061lQI25p-pyCiuahubVqaC6zZOuNJOkFNq_cvy6_z7QyM_GJh99IMMv1DRD1auwBKZ7Ii7go6Z5koZoqfyYS5R6miECBUCiN-8sLKlDCQo7Ry2-VZMsFNCA-xbZCZ1';

  bool _isGoogleLoading = false;

  void _openLogin(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LoginPage()));
  }

  void _openSignUp(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SignUpPage()));
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'http://localhost:3000',
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Google gagal')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.two_wheeler,
                          color: AppColors.onPrimary,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'motoservis',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.56,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _isGoogleLoading ? null : () => _openLogin(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    textStyle: theme.textTheme.labelLarge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Masuk dengan Email'),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _isGoogleLoading ? null : _loginWithGoogle,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                    textStyle: theme.textTheme.labelLarge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    width: 22,
                    height: 22,
                  ),
                  label: Text(
                    _isGoogleLoading
                        ? 'Membuka Google...'
                        : 'Masuk dengan Google',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: _isGoogleLoading ? null : () => _openSignUp(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: theme.textTheme.labelLarge,
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
  }
}

class _BrandPattern extends StatelessWidget {
  const _BrandPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BrandPatternPainter());
  }
}

class _BrandPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.05);

    for (double x = 2; x < size.width; x += 24) {
      for (double y = 2; y < size.height; y += 24) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Text(
        'G',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          height: 1.0,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4285F4),
          letterSpacing: -1,
        ),
      ),
    );
  }
}