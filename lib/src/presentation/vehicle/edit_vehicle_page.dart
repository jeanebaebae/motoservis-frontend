import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../core/theme/app_colors.dart';

class EditVehiclePage extends StatefulWidget {
  const EditVehiclePage({
    super.key,
    required this.vehicleId,
    required this.initialName,
    required this.initialBrand,
    required this.initialYear,
    required this.initialPlateNumber,
  });

  final String vehicleId;
  final String initialName;
  final String initialBrand;
  final int initialYear;
  final String initialPlateNumber;

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiClient _apiClient = ApiClient();

  late final TextEditingController _nameController;
  late final TextEditingController _plateController;

  String? _brand;
  String? _year;

  bool _isLoading = false;

  final List<String> _brands = [
    'Honda',
    'Yamaha',
    'Suzuki',
    'Kawasaki',
    'Vespa',
  ];

  final List<String> _years = [
    '2026',
    '2025',
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

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName);
    _plateController = TextEditingController(text: widget.initialPlateNumber);

    _brand = widget.initialBrand;
    _year = widget.initialYear.toString();

    if (!_brands.contains(_brand)) {
      _brands.add(_brand!);
    }

    if (!_years.contains(_year)) {
      _years.add(_year!);
      _years.sort((a, b) => b.compareTo(a));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _plateController.dispose();
    super.dispose();
  }

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

  Future<void> _updateVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiClient.put(
        '${ApiConstants.baseUrl}/vehicles/${widget.vehicleId}',
        {
          'name': _nameController.text.trim(),
          'brand': _brand,
          'year': int.parse(_year!),
          'plate_number': _plateController.text.trim().toUpperCase(),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data kendaraan berhasil diperbarui!'),
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

  Future<void> _confirmDeleteVehicle() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kendaraan'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus kendaraan ini? Reminder dan riwayat servis kendaraan ini juga akan terhapus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onError,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiClient.delete(
        '${ApiConstants.baseUrl}/vehicles/${widget.vehicleId}',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendaraan berhasil dihapus'),
        ),
      );

      Navigator.pop(context, 'deleted');
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
          'Edit Kendaraan',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            onPressed: _isLoading ? null : _confirmDeleteVehicle,
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
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
                  'Ubah informasi kendaraan Anda. Odometer dapat diperbarui langsung dari halaman detail kendaraan.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                Text('Nama Alias', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration('Contoh: Motor Harian'),
                  style: theme.textTheme.bodyMedium,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama alias tidak boleh kosong';
                    }
                    return null;
                  },
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
                            value: _brand,
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
                            value: _year,
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
                  controller: _plateController,
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
                ),

                const SizedBox(height: 32),
                const Divider(color: AppColors.outlineVariant),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _isLoading ? null : _updateVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.6),
                    disabledForegroundColor:
                        AppColors.onPrimary.withValues(alpha: 0.8),
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
                            color: AppColors.onPrimary,
                          ),
                        )
                      else
                        const Icon(Icons.save, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
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
        ),
      ),
    );
  }
}