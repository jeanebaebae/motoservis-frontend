import 'package:flutter/material.dart';

import '../auth/login_page.dart';
import '../auth/sign_up_page.dart';
import '../core/theme/app_colors.dart';
import '../dashboard/dashboard_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const _heroImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCVCg1r0yIsBiH781LV70_rRSdC5Ng2ngV0uF_GBelX6XV1YrrCri6DpOBv8tYlSdoUyB5okDo8wH6nl4kDOcjiDh8EXI2e1m2L6w0sb7TCoXYhTqEGljZxrOsZHzOeRdKfoiP_RHjEDBRTv061lQI25p-pyCiuahubVqaC6zZOuNJOkFNq_cvy6_z7QyM_GJh99IMMv1DRD1auwBKZ7Ii7go6Z5koZoqfyYS5R6miECBUCiN-8sLKlDCQo7Ry2-VZMsFNCA-xbZCZ1';

  void _openDashboard(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const DashboardPage()),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _BrandPattern()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.surfaceContainerLow],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 448,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 32,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 32),
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.two_wheeler,
                                    color: AppColors.onPrimary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'MotoServis',
                                  style: theme.textTheme.displayMedium
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        letterSpacing: -0.56,
                                      ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 280,
                                      maxHeight: 280,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            32,
                                          ),
                                          border: Border.all(
                                            color: AppColors.outlineVariant
                                                .withValues(alpha: 0.3),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x22000000),
                                              blurRadius: 24,
                                              offset: Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            32,
                                          ),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.network(
                                                _heroImageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        color: AppColors
                                                            .surfaceContainerLowest,
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Icon(
                                                          Icons.two_wheeler,
                                                          size: 64,
                                                          color:
                                                              AppColors.outline,
                                                        ),
                                                      );
                                                    },
                                              ),
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black.withValues(
                                                        alpha: 0.2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 280,
                                    ),
                                    child: Text(
                                      'Kelola servis motormu dengan mudah',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 56,
                                  child: FilledButton(
                                    onPressed: () => _openLogin(context),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.onPrimary,
                                      textStyle: theme.textTheme.labelLarge,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                                    onPressed: () => _openDashboard(context),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.surfaceContainerLowest,
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.outlineVariant,
                                      ),
                                      textStyle: theme.textTheme.labelLarge,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const _GoogleIcon(),
                                    label: const Text('Masuk dengan Google'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Center(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'Belum punya akun? ',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppColors.onSurfaceVariant,
                                              ),
                                        ),
                                        TextButton(
                                          onPressed: () => _openSignUp(context),
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppColors.primary,
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            textStyle:
                                                theme.textTheme.labelLarge,
                                          ),
                                          child: const Text('Daftar Sekarang'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final blue = Paint()..color = const Color(0xFF4285F4);
    final green = Paint()..color = const Color(0xFF34A853);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final red = Paint()..color = const Color(0xFFEA4335);

    canvas.drawPath(
      Path()
        ..moveTo(width * 0.94, height * 0.52)
        ..cubicTo(
          width * 0.94,
          height * 0.49,
          width * 0.94,
          height * 0.45,
          width * 0.93,
          height * 0.42,
        )
        ..lineTo(width * 0.50, height * 0.42)
        ..lineTo(width * 0.50, height * 0.60)
        ..lineTo(width * 0.75, height * 0.60)
        ..cubicTo(
          width * 0.73,
          height * 0.66,
          width * 0.67,
          height * 0.71,
          width * 0.59,
          height * 0.74,
        )
        ..lineTo(width * 0.59, height * 0.86)
        ..lineTo(width * 0.89, height * 0.86)
        ..cubicTo(
          width * 0.99,
          height * 0.77,
          width * 1.04,
          height * 0.64,
          width * 0.94,
          height * 0.52,
        )
        ..close(),
      blue,
    );

    canvas.drawPath(
      Path()
        ..moveTo(width * 0.50, height * 0.96)
        ..cubicTo(
          width * 0.75,
          height * 0.96,
          width * 0.88,
          height * 0.88,
          width * 0.96,
          height * 0.81,
        )
        ..lineTo(width * 0.81, height * 0.69)
        ..cubicTo(
          width * 0.75,
          height * 0.73,
          width * 0.65,
          height * 0.77,
          width * 0.50,
          height * 0.77,
        )
        ..cubicTo(
          width * 0.28,
          height * 0.77,
          width * 0.09,
          height * 0.61,
          width * 0.02,
          height * 0.40,
        )
        ..lineTo(width * 0.02, height * 0.80)
        ..cubicTo(
          width * 0.16,
          height * 0.90,
          width * 0.32,
          height * 0.96,
          width * 0.50,
          height * 0.96,
        )
        ..close(),
      green,
    );

    canvas.drawPath(
      Path()
        ..moveTo(width * 0.02, height * 0.40)
        ..cubicTo(
          width * -0.02,
          height * 0.29,
          width * -0.02,
          height * 0.17,
          width * 0.02,
          height * 0.06,
        )
        ..lineTo(width * 0.18, height * 0.18)
        ..cubicTo(
          width * 0.15,
          height * 0.24,
          width * 0.13,
          height * 0.30,
          width * 0.13,
          height * 0.36,
        )
        ..cubicTo(
          width * 0.13,
          height * 0.42,
          width * 0.15,
          height * 0.48,
          width * 0.18,
          height * 0.54,
        )
        ..lineTo(width * 0.02, height * 0.66)
        ..close(),
      yellow,
    );

    canvas.drawPath(
      Path()
        ..moveTo(width * 0.50, height * 0.12)
        ..cubicTo(
          width * 0.62,
          height * 0.12,
          width * 0.72,
          height * 0.16,
          width * 0.81,
          height * 0.23,
        )
        ..lineTo(width * 0.95, height * 0.09)
        ..cubicTo(
          width * 0.84,
          height * 0.00,
          width * 0.68,
          height * -0.04,
          width * 0.50,
          height * -0.04,
        )
        ..cubicTo(
          width * 0.32,
          height * -0.04,
          width * 0.16,
          height * 0.02,
          width * 0.02,
          height * 0.18,
        )
        ..lineTo(width * 0.18, height * 0.30)
        ..cubicTo(
          width * 0.24,
          height * 0.19,
          width * 0.35,
          height * 0.12,
          width * 0.50,
          height * 0.12,
        )
        ..close(),
      red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
