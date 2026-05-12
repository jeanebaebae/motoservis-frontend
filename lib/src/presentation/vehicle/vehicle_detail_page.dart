import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../service/record_service_page.dart';
import 'edit_vehicle_page.dart';

class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Vario 160 Harian',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: AppColors.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditVehiclePage(),
                ),
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: AppColors.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Identity Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
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
                  // Top Accent Border
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 4,
                    child: Container(color: AppColors.primary),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KENDARAAN',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Honda Vario 160\n2023',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.directions_car, size: 16, color: AppColors.onSurface),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Plat: B 1234 ABC',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Odometer Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.speed, color: AppColors.onPrimaryContainer),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Odometer Saat Ini',
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            '12.450',
                                            style: theme.textTheme.headlineMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'km',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.secondary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditVehiclePage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Tambah Reminder'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: theme.textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: theme.textTheme.labelLarge,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Lihat Riwayat Servis'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Jadwal Servis Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jadwal Servis',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '1 Perhatian',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Service Reminders
            _buildServiceReminderCard(
              context,
              theme,
              title: 'Oli Mesin',
              remainingText: 'Sisa: 50 km',
              icon: Icons.warning,
              isWarning: true,
              lastService: '11.000 km',
              targetService: '12.500 km',
              progress: 0.96,
            ),
            const SizedBox(height: 16),
            _buildServiceReminderCard(
              context,
              theme,
              title: 'Filter Udara',
              remainingText: 'Sisa: 2.550 km',
              icon: Icons.check_circle,
              isWarning: false,
              lastService: '7.000 km',
              targetService: '15.000 km',
              progress: 0.31,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceReminderCard(
    BuildContext context,
    ThemeData theme, {
    required String title,
    required String remainingText,
    required IconData icon,
    required bool isWarning,
    required String lastService,
    required String targetService,
    required double progress,
  }) {
    final accentColor = isWarning ? AppColors.secondaryContainer : AppColors.primary;
    final iconBgColor = isWarning 
        ? AppColors.secondaryContainer.withValues(alpha: 0.1) 
        : AppColors.primary.withValues(alpha: 0.1);
    final iconColor = isWarning ? AppColors.secondaryContainer : AppColors.primary;
    final titleColor = AppColors.onSurface;
    final remainingColor = isWarning ? AppColors.error : AppColors.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
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
          // Left Accent Bar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(color: accentColor),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
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
                              style: theme.textTheme.bodySmall?.copyWith(
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
                        side: isWarning ? null : BorderSide(color: AppColors.primary),
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
                    backgroundColor: AppColors.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
