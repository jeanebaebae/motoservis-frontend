import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../service/record_service_page.dart';

class ServisTab extends StatelessWidget {
  const ServisTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jadwal Servis Header
                    Text(
                      'Jadwal Servis',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pantau kesehatan semua kendaraan Anda dalam satu tempat.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Perlu Perhatian Section
                    Row(
                      children: [
                        const Icon(Icons.report, color: AppColors.error),
                        const SizedBox(width: 8),
                        Text(
                          'Perlu Perhatian',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildServiceScheduleCard(
                      context,
                      theme,
                      title: 'Oli Mesin',
                      remainingText: 'Sisa: 50 km',
                      icon: Icons.warning,
                      isWarning: true,
                      lastService: '11.000 km',
                      targetService: '12.500 km',
                      progress: 0.96,
                      vehicleName: 'Vario 160 Harian',
                    ),
                    const SizedBox(height: 32),

                    // Mendatang Section
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Mendatang',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildServiceScheduleCard(
                      context,
                      theme,
                      title: 'Filter Udara',
                      remainingText: 'Sisa: 2.550 km',
                      icon: Icons.check_circle,
                      isWarning: false,
                      lastService: '7.000 km',
                      targetService: '15.000 km',
                      progress: 0.31,
                      vehicleName: 'NMAX Weekend',
                    ),
                    const SizedBox(height: 16),
                    _buildServiceScheduleCard(
                      context,
                      theme,
                      title: 'Oli Gardan',
                      remainingText: 'Sisa: 3.000 km',
                      icon: Icons.check_circle,
                      isWarning: false,
                      lastService: '12.000 km',
                      targetService: '20.000 km',
                      progress: 0.25,
                      vehicleName: 'Vario 160 Harian',
                    ),
                    const SizedBox(height: 16),
                    _buildServiceScheduleCard(
                      context,
                      theme,
                      title: 'CVT / V-Belt',
                      remainingText: 'Sisa: 8.000 km',
                      icon: Icons.check_circle,
                      isWarning: false,
                      lastService: '12.000 km',
                      targetService: '25.000 km',
                      progress: 0.15,
                      vehicleName: 'NMAX Weekend',
                    ),
                  ],
                ),
              ),
            ),
            
            // Fixed Bottom Summary Area
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: AppColors.background,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.build_circle, color: AppColors.primaryFixed),
                            const SizedBox(height: 8),
                            Text(
                              'Total Servis',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
                              ),
                            ),
                            Text(
                              '4',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24), // Placeholder for the removed ! icon to maintain alignment
                            const SizedBox(height: 8),
                            Text(
                              'Perlu Tindakan',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.onSecondaryContainer.withValues(alpha: 0.8),
                              ),
                            ),
                            Text(
                              '1',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
      ],
    );
  }

  Widget _buildServiceScheduleCard(
    BuildContext context,
    ThemeData theme, {
    required String title,
    required String remainingText,
    required IconData icon,
    required bool isWarning,
    required String lastService,
    required String targetService,
    required double progress,
    required String vehicleName,
  }) {
    final accentColor = isWarning ? AppColors.secondaryContainer : AppColors.primary;
    final iconBgColor = isWarning 
        ? AppColors.secondaryFixed 
        : AppColors.surfaceContainer;
    final iconColor = isWarning ? AppColors.secondaryContainer : AppColors.onSurfaceVariant;
    final titleColor = AppColors.onSurface;
    final remainingColor = isWarning ? AppColors.error : AppColors.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left Accent Bar (6px wide)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: Container(color: accentColor),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: iconColor),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              remainingText,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: remainingColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordServicePage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.build, size: 16),
                      label: const Text('Catat Servis'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isWarning ? AppColors.secondaryContainer : AppColors.surfaceContainerLowest,
                        foregroundColor: isWarning ? AppColors.onSecondaryContainer : AppColors.primary,
                        side: isWarning ? null : const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textStyle: theme.textTheme.labelLarge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: isWarning ? 2 : 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terakhir: $lastService',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Target: $targetService',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // NEW: Kendaraan name bold and slightly bigger
                Text(
                  'Kendaraan: $vehicleName',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
