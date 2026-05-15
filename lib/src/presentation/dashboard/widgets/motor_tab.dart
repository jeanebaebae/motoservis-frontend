import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../vehicle/add_vehicle_page.dart';
import '../../vehicle/vehicle_detail_page.dart';
import 'vehicle_compact_card.dart';

class MotorTab extends StatefulWidget {
  const MotorTab({super.key});

  @override
  State<MotorTab> createState() => _MotorTabState();
}

class _MotorTabState extends State<MotorTab> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.get(
        '${ApiConstants.baseUrl}/dashboard',
      );

      final data = response['data'];
      final vehicles = data['vehicles'] as List? ?? [];

      setState(() {
        _vehicles = vehicles;
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

    final formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return '$formatted km';
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
                onPressed: _loadVehicles,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVehicles,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kendaraan Saya',
              style: theme.textTheme.displayLarge?.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelola daftar sepeda motor dan jadwal servis Anda.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            if (_vehicles.isEmpty)
              Text(
                'Belum ada kendaraan. Tambahkan kendaraan pertama Anda.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              )
            else
              ..._vehicles.map((vehicle) {
                final attentionReminders =
                    (vehicle['attention_reminders'] as List?) ?? [];

                final isWarning = attentionReminders.isNotEmpty;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: VehicleCompactCard(
                    name: vehicle['name'] ?? '-',
                    plateNumber: vehicle['plate_number'] ?? '-',
                    mileage: _formatKm(vehicle['current_odometer']),
                    isWarning: isWarning,
                    statusText: isWarning ? 'Perlu Perhatian' : 'Servis OK',
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

            const SizedBox(height: 32),

            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddVehiclePage(),
                    ),
                  );

                  _loadVehicles();
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Tambah Kendaraan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: theme.textTheme.labelLarge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}