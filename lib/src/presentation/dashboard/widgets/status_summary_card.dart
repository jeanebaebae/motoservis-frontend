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

    const warningColor = Color.fromARGB(255, 255, 103, 21);
    const normalCardColor = Color(0xFF0D1B2E);
    const normalIconBgColor = Color(0xFFE8EEF8);
    const normalTextColor = Color(0xFF8E9AAF);

    final bgColor = isWarning ? warningColor : normalCardColor;
    final borderColor = isWarning ? warningColor : normalCardColor;

    final titleColor = isWarning ? Colors.black87 : normalTextColor;
    final valueColor = isWarning ? Colors.black : normalTextColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isWarning
                ? Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: warningColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: normalIconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: normalCardColor,
                      size: 18,
                    ),
                  ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: titleColor,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}