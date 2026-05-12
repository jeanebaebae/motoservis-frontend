import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class VehicleCompactCard extends StatelessWidget {
  final String name;
  final String plateNumber;
  final String mileage;
  final bool isWarning;
  final String statusText;
  final VoidCallback? onTap;

  const VehicleCompactCard({
    super.key,
    required this.name,
    required this.plateNumber,
    required this.mileage,
    required this.isWarning,
    required this.statusText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = isWarning ? AppColors.secondaryContainer : Colors.green;
    
    // Status pill colors
    final pillBgColor = isWarning 
        ? AppColors.secondaryContainer.withValues(alpha: 0.15)
        : AppColors.surfaceContainerHigh;
    final pillTextColor = isWarning ? AppColors.secondaryContainer : AppColors.onSurface;
    final pillIconColor = isWarning ? AppColors.secondaryContainer : Colors.green;
    final pillIcon = isWarning ? Icons.warning_amber_rounded : Icons.check_circle_outline;

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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16), // Extra left padding for accent bar
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      plateNumber,
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Status Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: pillBgColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      pillIcon,
                                      size: 16,
                                      color: pillIconColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      statusText,
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: pillTextColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Mileage
                          Row(
                            children: [
                              const Icon(
                                Icons.speed,
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
                    ),
                    const SizedBox(width: 8),
                    // Chevron
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.outline,
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
