import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'status_summary_card.dart';
import 'vehicle_card.dart';
import '../../vehicle/add_vehicle_page.dart';
import '../../vehicle/vehicle_detail_page.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 100, // padding for bottom nav
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Section
          Text(
            'Halo, Budi! 👋',
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

          // Status Summary
          Row(
            children: [
              Expanded(
                child: StatusSummaryCard(
                  title: 'Terdaftar',
                  value: '2 kendaraan',
                  icon: Icons.motorcycle, // Placeholders for material_symbols
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatusSummaryCard(
                  title: 'Perhatian',
                  value: '1 perlu servis',
                  icon: Icons.warning,
                  isWarning: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Vehicle List Header
          Text(
            'Kendaraan Saya',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Vehicle Card 1 (Warning)
          VehicleCard(
            name: 'Vario 160 Harian',
            plateNumber: 'B 1234 ABC',
            mileage: '12.450 km',
            isWarning: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleDetailPage(),
                ),
              );
            },
            services: [
              VehicleServiceItem(
                name: 'Oli Mesin',
                icon: Icons.water_drop,
                statusText: 'Sisa: 50 km',
                progress: 0.66,
                isWarning: true,
              ),
              VehicleServiceItem(
                name: 'Filter Udara',
                icon: Icons.air,
                statusText: 'Sisa: 2.550 km',
                progress: 1.0,
                isWarning: false,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Vehicle Card 2 (OK)
          VehicleCard(
            name: 'NMAX Weekend',
            plateNumber: 'B 5678 DEF',
            mileage: '8.200 km',
            isWarning: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleDetailPage(),
                ),
              );
            },
            services: const [],
          ),
          const SizedBox(height: 24),

          // Primary Action
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddVehiclePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
              minimumSize: const Size(double.infinity, 48), // Full width
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
    );
  }
}
