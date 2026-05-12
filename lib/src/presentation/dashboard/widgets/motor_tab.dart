import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'vehicle_compact_card.dart';
import '../../vehicle/add_vehicle_page.dart';
import '../../vehicle/vehicle_detail_page.dart';

class MotorTab extends StatelessWidget {
  const MotorTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: 100, // padding for bottom nav
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title & Subtitle
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

          // Vehicle List
          VehicleCompactCard(
            name: 'Vario 160 Harian',
            plateNumber: 'B 1234 ABC',
            mileage: '12.450 km',
            isWarning: true,
            statusText: 'Servis Segera',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleDetailPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          VehicleCompactCard(
            name: 'NMAX Weekend',
            plateNumber: 'B 5678 DEF',
            mileage: '8.200 km',
            isWarning: false,
            statusText: 'Service OK',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleDetailPage(),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),

          // Primary Action
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddVehiclePage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Tambah Kendaraan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
    );
  }
}
