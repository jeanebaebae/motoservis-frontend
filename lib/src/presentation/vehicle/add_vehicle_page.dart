import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../core/theme/app_colors.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = false;

  String? _alias;
  String? _brand;
  String? _year;
  String? _plate;
  String? _odometer;

  final List<String> _brands = [
    'Honda',
    'Yamaha',
    'Suzuki',
    'Kawasaki',
    'Vespa',
  ];

  final List<String> _years = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
  ];

  InputDecoration _buildInputDecoration(String labelText, {Widget? prefixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      hintText: labelText,
      hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiClient.post(
        '${ApiConstants.baseUrl}/vehicles',
        {
          'name': _alias!.trim(),
          'brand': _brand,
          'year': int.parse(_year!),
          'plate_number': _plate!.trim().toUpperCase(),
          'current_odometer': int.parse(_odometer!),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendaraan berhasil disimpan!'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Kendaraan',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
          ),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
          bottom: 40,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan detail kendaraan Anda untuk mulai melacak riwayat servis dan pengingat pemeliharaan.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                Text('Nama Alias', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                TextFormField(
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration('Contoh: Motor Harian'),
                  style: theme.textTheme.bodyMedium,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama alias tidak boleh kosong';
                    }
                    return null;
                  },
                  onSaved: (value) => _alias = value,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Merek', style: theme.textTheme.labelLarge),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            decoration: _buildInputDecoration('Pilih Merek'),
                            items: _brands.map((String brand) {
                              return DropdownMenuItem(
                                value: brand,
                                child: Text(
                                  brand,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: _isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _brand = value;
                                    });
                                  },
                            validator: (value) {
                              if (value == null) {
                                return 'Pilih merek';
                              }
                              return null;
                            },
                            onSaved: (value) => _brand = value,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tahun', style: theme.textTheme.labelLarge),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            decoration: _buildInputDecoration('Pilih Tahun'),
                            items: _years.map((String year) {
                              return DropdownMenuItem(
                                value: year,
                                child: Text(
                                  year,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: _isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _year = value;
                                    });
                                  },
                            validator: (value) {
                              if (value == null) {
                                return 'Pilih tahun';
                              }
                              return null;
                            },
                            onSaved: (value) => _year = value,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text('Nomor Plat', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                TextFormField(
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration('B 1234 ABC'),
                  style: theme.textTheme.bodyMedium,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor plat tidak boleh kosong';
                    }
                    return null;
                  },
                  onSaved: (value) => _plate = value,
                ),
                const SizedBox(height: 16),

                Text(
                  'Odometer Saat Ini (KM)',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration(
                    '12000',
                    prefixIcon: const Icon(
                      Icons.speed,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Odometer tidak boleh kosong';
                    }

                    final odometer = int.tryParse(value);

                    if (odometer == null) {
                      return 'Odometer harus berupa angka';
                    }

                    if (odometer < 0) {
                      return 'Odometer tidak boleh negatif';
                    }

                    return null;
                  },
                  onSaved: (value) => _odometer = value,
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimasi jarak tempuh terakhir untuk mengatur jadwal servis.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                const Divider(color: AppColors.outlineVariant),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _isLoading ? null : _saveVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiaryContainer,
                    foregroundColor: AppColors.onTertiary,
                    disabledBackgroundColor:
                        AppColors.tertiaryContainer.withValues(alpha: 0.6),
                    disabledForegroundColor:
                        AppColors.onTertiary.withValues(alpha: 0.8),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onTertiary,
                          ),
                        )
                      else
                        const Icon(Icons.save, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isLoading ? 'Menyimpan...' : 'Simpan Kendaraan',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.onTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}