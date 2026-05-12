import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isWarning;

  const StatusSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isWarning
        ? AppColors.secondaryContainer.withValues(alpha: 0.3)
        : AppColors.outlineVariant;
    final iconColor = isWarning ? AppColors.secondaryContainer : AppColors.outline;
    final titleColor = isWarning
        ? AppColors.secondaryContainer
        : AppColors.onSurfaceVariant;
    final bgColor = AppColors.surfaceContainerLowest;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
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
          if (isWarning)
            Positioned.fill(
              child: Container(
                color: AppColors.secondaryContainer.withValues(alpha: 0.05),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                      // Apply fill logic if needed via Theme or Custom Icon properties
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: titleColor,
                        letterSpacing: 0.5,
                        fontWeight: isWarning ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.onSurface,
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
