import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class VehicleServiceItem {
  final String name;
  final IconData icon;
  final String statusText;
  final double progress; // 0.0 to 1.0
  final bool isWarning;

  const VehicleServiceItem({
    required this.name,
    required this.icon,
    required this.statusText,
    required this.progress,
    this.isWarning = false,
  });
}

class VehicleCard extends StatelessWidget {
  final String name;
  final String plateNumber;
  final String mileage;
  final bool isWarning;
  final List<VehicleServiceItem> services;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.name,
    required this.plateNumber,
    required this.mileage,
    required this.isWarning,
    required this.services,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = isWarning ? AppColors.secondaryContainer : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
          Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.surfaceContainer),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                plateNumber,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.speed, // Placeholder for material_symbols speed
                                  size: 16,
                                  color: AppColors.outline,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  mileage,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.outline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      color: AppColors.onSurfaceVariant,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Body
              Container(
                color: AppColors.surfaceBright,
                padding: const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16),
                child: services.isEmpty
                    ? Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Semua servis OK',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: services.asMap().entries.map((entry) {
                          final int idx = entry.key;
                          final VehicleServiceItem service = entry.value;
                          return Column(
                            children: [
                              if (idx > 0)
                                const Divider(
                                  color: AppColors.surfaceContainer,
                                  height: 32,
                                  thickness: 1,
                                ),
                              _buildServiceRow(theme, service),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildServiceRow(ThemeData theme, VehicleServiceItem service) {
    final statusColor = service.isWarning ? AppColors.secondaryContainer : AppColors.primary;
    final iconColor = service.isWarning ? AppColors.secondaryContainer : AppColors.outline;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(service.icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  service.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: service.isWarning 
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 2)
                  : EdgeInsets.zero,
              decoration: service.isWarning 
                  ? BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: Row(
                children: [
                  if (!service.isWarning) ...[
                    Icon(Icons.check_circle, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    service.statusText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: service.progress,
            backgroundColor: AppColors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
