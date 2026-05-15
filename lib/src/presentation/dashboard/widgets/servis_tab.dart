import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../service/record_service_page.dart';

class ServisTab extends StatefulWidget {
  const ServisTab({super.key});

  @override
  State<ServisTab> createState() => _ServisTabState();
}

class _ServisTabState extends State<ServisTab> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.get(
        '${ApiConstants.baseUrl}/reminders',
      );

      setState(() {
        _reminders = response['data'] ?? [];
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatKm(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;

    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  IconData _getIcon(String serviceType, bool isWarning) {
    if (isWarning) return Icons.warning;

    switch (serviceType.toLowerCase()) {
      case 'oli mesin':
      case 'oli gardan':
        return Icons.water_drop;
      case 'filter udara':
        return Icons.air;
      case 'busi':
        return Icons.bolt;
      case 'kampas rem':
        return Icons.radio_button_checked;
      case 'ban':
        return Icons.circle;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadReminders,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final attentionReminders = _reminders.where((reminder) {
      return reminder['status'] == 'Perlu Perhatian';
    }).toList();

    final upcomingReminders = _reminders.where((reminder) {
      return reminder['status'] != 'Perlu Perhatian';
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadReminders,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Servis',
                        style: theme.textTheme.displayLarge?.copyWith(
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

                      if (attentionReminders.isEmpty)
                        Text(
                          'Tidak ada servis yang perlu perhatian.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        )
                      else
                        ...attentionReminders.map((reminder) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildServiceScheduleCard(
                              context,
                              theme,
                              reminder: reminder,
                            ),
                          );
                        }),

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                          ),
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

                      if (upcomingReminders.isEmpty)
                        Text(
                          'Belum ada jadwal servis mendatang.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        )
                      else
                        ...upcomingReminders.map((reminder) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildServiceScheduleCard(
                              context,
                              theme,
                              reminder: reminder,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),

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
                              const Icon(
                                Icons.build_circle,
                                color: AppColors.primaryFixed,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total Servis',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.onPrimaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                '${_reminders.length}',
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
                              const SizedBox(height: 24),
                              const SizedBox(height: 8),
                              Text(
                                'Perlu Tindakan',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSecondaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                '${attentionReminders.length}',
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
      ),
    );
  }

  Widget _buildServiceScheduleCard(
    BuildContext context,
    ThemeData theme, {
    required dynamic reminder,
  }) {
    final isWarning = reminder['status'] == 'Perlu Perhatian';

    final serviceType = reminder['service_type'] ?? '-';
    final vehicleName = reminder['vehicle_name'] ?? '-';
    final remainingKm = reminder['remaining_km'] ?? 0;
    final progressPercent = reminder['progress_percentage'] ?? 0;
    final progress = (progressPercent / 100).clamp(0.0, 1.0);

    final accentColor =
        isWarning ? AppColors.secondaryContainer : AppColors.primary;
    final iconBgColor =
        isWarning ? AppColors.secondaryFixed : AppColors.surfaceContainer;
    final iconColor =
        isWarning ? AppColors.secondaryContainer : AppColors.onSurfaceVariant;
    final remainingColor =
        isWarning ? AppColors.error : AppColors.onSurfaceVariant;

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
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: Container(color: accentColor),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 22,
              top: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIcon(serviceType, isWarning),
                              color: iconColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceType,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sisa: ${_formatKm(remainingKm)} km',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: remainingColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordServicePage(
                              vehicleId: reminder['vehicle_id'],
                              reminderId: reminder['id'],
                              vehicleName: vehicleName,
                              serviceType: serviceType,
                              currentOdometer: reminder['current_odometer'],
                            ),
                          ),
                        );

                        if (result == true) {
                          _loadReminders();
                        }
                      },
                      icon: const Icon(Icons.build, size: 16),
                      label: const Text('Catat Servis'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isWarning
                            ? AppColors.secondaryContainer
                            : AppColors.surfaceContainerLowest,
                        foregroundColor: isWarning
                            ? AppColors.onSecondaryContainer
                            : AppColors.primary,
                        side: isWarning
                            ? null
                            : const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terakhir: ${_formatKm(reminder['last_service_km'])} km',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Target: ${_formatKm(reminder['next_service_km'])} km',
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