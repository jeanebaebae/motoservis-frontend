import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../vehicle/add_vehicle_page.dart';
import '../../vehicle/vehicle_detail_page.dart';
import 'status_summary_card.dart';
import 'vehicle_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _dashboardData;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.get(
        '${ApiConstants.baseUrl}/dashboard',
      );

      setState(() {
        _dashboardData = response['data'];
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
    return '${number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )} km';
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'oli mesin':
      case 'oli gardan':
        return Icons.water_drop;
      case 'filter udara':
        return Icons.air;
      case 'rantai':
        return Icons.link;
      case 'kampas rem':
        return Icons.radio_button_checked;
      case 'busi':
        return Icons.bolt;
      case 'ban':
        return Icons.circle;
      default:
        return Icons.build;
    }
  }

  List<VehicleServiceItem> _mapAttentionReminders(List reminders) {
    return reminders.map<VehicleServiceItem>((reminder) {
      final progressPercent = reminder['progress_percentage'] ?? 0;
      final progress = (progressPercent / 100).clamp(0.0, 1.0);

      return VehicleServiceItem(
        name: reminder['service_type'] ?? '-',
        icon: _getServiceIcon(reminder['service_type'] ?? ''),
        statusText: 'Sisa: ${_formatKm(reminder['remaining_km'])}',
        progress: progress,
        isWarning: true,
      );
    }).toList();
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
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDashboard,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final summary = _dashboardData?['summary'] ?? {};
    final vehicles = (_dashboardData?['vehicles'] as List?) ?? [];

    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo! 👋',
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Ringkasan garasi Anda hari ini.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: StatusSummaryCard(
                    title: 'Terdaftar',
                    value: '${summary['total_vehicles'] ?? 0} kendaraan',
                    icon: Icons.motorcycle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatusSummaryCard(
                    title: 'Perhatian',
                    value:
                        '${summary['total_attention_vehicles'] ?? 0} perlu servis',
                    icon: Icons.warning,
                    isWarning: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              'Kendaraan Saya',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            if (vehicles.isEmpty)
              Text(
                'Belum ada kendaraan. Tambahkan kendaraan pertama Anda.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              )
            else
              ...vehicles.map((vehicle) {
                final attentionReminders =
                    (vehicle['attention_reminders'] as List?) ?? [];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: VehicleCard(
                    name: vehicle['name'] ?? '-',
                    plateNumber: vehicle['plate_number'] ?? '-',
                    mileage: _formatKm(vehicle['current_odometer']),
                    isWarning: attentionReminders.isNotEmpty,
                    services: _mapAttentionReminders(attentionReminders),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleDetailPage(
                            vehicleId: vehicle['id'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddVehiclePage(),
                  ),
                );

                _loadDashboard();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Tambah Kendaraan',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}