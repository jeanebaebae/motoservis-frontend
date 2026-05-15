import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../core/theme/app_colors.dart';
import '../service/record_service_page.dart';
import 'edit_vehicle_page.dart';
import 'add_reminder_page.dart';
import '../service/service_history_page.dart';

class VehicleDetailPage extends StatefulWidget {
  const VehicleDetailPage({
    super.key,
    required this.vehicleId,
  });

  final String vehicleId;

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _detailData;

  @override
  void initState() {
    super.initState();
    _loadVehicleDetail();
  }

  Future<void> _showUpdateOdometerDialog(dynamic currentOdometer) async {
    final controller = TextEditingController(
      text: currentOdometer.toString(),
    );

  final newOdometer = await showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Odometer'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Odometer saat ini',
            suffixText: 'km',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());

              if (value == null) {
                return;
              }

              Navigator.pop(context, value);
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    },
  );

  controller.dispose();

  if (newOdometer == null) return;

  try {
    await _apiClient.patch(
      '${ApiConstants.baseUrl}/vehicles/${widget.vehicleId}/odometer',
      {
        'current_odometer': newOdometer,
      },
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Odometer berhasil diperbarui'),
      ),
    );

    await _loadVehicleDetail();
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
      ),
    );
  }
}

  Future<void> _loadVehicleDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.get(
        '${ApiConstants.baseUrl}/vehicles/${widget.vehicleId}/detail',
      );

      setState(() {
        _detailData = response['data'];
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

  IconData _getReminderIcon(bool isWarning) {
    return isWarning ? Icons.warning : Icons.check_circle;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Kendaraan'),
        ),
        body: Center(
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
                  onPressed: _loadVehicleDetail,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final vehicle = _detailData?['vehicle'] ?? {};
    final reminderSummary = _detailData?['reminder_summary'] ?? {};
    final reminders = (_detailData?['reminders'] as List?) ?? [];

    final vehicleName = vehicle['name'] ?? '-';
    final brand = vehicle['brand'] ?? '-';
    final year = vehicle['year']?.toString() ?? '-';
    final plateNumber = vehicle['plate_number'] ?? '-';
    final currentOdometer = vehicle['current_odometer'] ?? 0;
    final attentionCount = reminderSummary['attention_count'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Kendaraan',
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
      body: RefreshIndicator(
        onRefresh: _loadVehicleDetail,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVehicleIdentityCard(
                context,
                theme,
                brand: brand,
                year: year,
                plateNumber: plateNumber,
                currentOdometer: currentOdometer,
              ),
              const SizedBox(height: 16),

              _buildQuickActionsCard(theme, currentOdometer, vehicleName),
              const SizedBox(height: 24),

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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: attentionCount > 0
                          ? AppColors.errorContainer
                          : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      attentionCount > 0
                          ? '$attentionCount Perhatian'
                          : 'Servis OK',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: attentionCount > 0
                            ? AppColors.onErrorContainer
                            : AppColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (reminders.isEmpty)
                Text(
                  'Belum ada reminder aktif.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                )
              else
                ...reminders.map((reminder) {
                  final status = reminder['status'] ?? 'Aman';
                  final isWarning = status == 'Perlu Perhatian';

                  final progressPercent =
                      reminder['progress_percentage'] ?? 0;
                  final progress =
                      (progressPercent / 100).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildServiceReminderCard(
                      context,
                      theme,
                      vehicleName: vehicleName,
                      vehicleId: widget.vehicleId,
                      reminderId: reminder['id'],
                      serviceType: reminder['service_type'],
                      currentOdometer: currentOdometer,
                      title: reminder['service_type'] ?? '-',
                      remainingText:
                          'Sisa: ${_formatKm(reminder['remaining_km'])} km',
                      icon: _getReminderIcon(isWarning),
                      isWarning: isWarning,
                      lastService:
                          '${_formatKm(reminder['last_service_km'])} km',
                      targetService:
                          '${_formatKm(reminder['next_service_km'])} km',
                      progress: progress,
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleIdentityCard(
    BuildContext context,
    ThemeData theme, {
    required String brand,
    required String year,
    required String plateNumber,
    required dynamic currentOdometer,
  }) {
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
                    Expanded(
                      child: Column(
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
                            '$brand\n$year',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.motorcycle,
                            size: 16,
                            color: AppColors.onSurface,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Plat: $plateNumber',
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
                            child: const Icon(
                              Icons.speed,
                              color: AppColors.onPrimaryContainer,
                            ),
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
                                    _formatKm(currentOdometer),
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
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
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.secondary,
                        ),
                        onPressed: () {
                          _showUpdateOdometerDialog(currentOdometer);
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
    );
  }

  Widget _buildQuickActionsCard(ThemeData theme, dynamic currentOdometer, String vehicleName) {
  return Container(
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
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddReminderPage(
                  vehicleId: widget.vehicleId,
                  currentOdometer: currentOdometer,
                ),
              ),
            );

            if (result == true) {
              _loadVehicleDetail();
            }
          },
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceHistoryPage(
                  vehicleId: widget.vehicleId, 
                  vehicleName: vehicleName,
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: theme.textTheme.labelLarge,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lihat Riwayat Servis'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildServiceReminderCard(
    BuildContext context,
    ThemeData theme, {
    required String vehicleName,
    required String vehicleId,
    required String reminderId,
    required String serviceType,
    required dynamic currentOdometer,
    required String title,
    required String remainingText,
    required IconData icon,
    required bool isWarning,
    required String lastService,
    required String targetService,
    required double progress,
  }) {
    final accentColor =
        isWarning ? AppColors.secondaryContainer : AppColors.primary;
    final iconBgColor = isWarning
        ? AppColors.secondaryContainer.withValues(alpha: 0.1)
        : AppColors.primary.withValues(alpha: 0.1);
    final iconColor =
        isWarning ? AppColors.secondaryContainer : AppColors.primary;
    final remainingColor =
        isWarning ? AppColors.error : AppColors.onSurfaceVariant;

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
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(color: accentColor),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
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
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  RecordServicePage(
                                      vehicleId: vehicleId,
                                      reminderId: reminderId,
                                      vehicleName: vehicleName,
                                      serviceType: serviceType,
                                      currentOdometer: currentOdometer,
                            ),
                          ),
                        );
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