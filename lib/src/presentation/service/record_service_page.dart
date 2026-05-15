import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../core/theme/app_colors.dart';

class RecordServicePage extends StatefulWidget {
  const RecordServicePage({
    super.key,
    required this.vehicleId,
    required this.reminderId,
    required this.vehicleName,
    required this.serviceType,
    required this.currentOdometer,
  });

  final String vehicleId;
  final String reminderId;
  final String vehicleName;
  final String serviceType;
  final dynamic currentOdometer;

  @override
  State<RecordServicePage> createState() => _RecordServicePageState();
}

class _RecordServicePageState extends State<RecordServicePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiClient _apiClient = ApiClient();

  late DateTime _selectedDate;
  late TextEditingController _odometerController;
  final TextEditingController _workshopController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;

  final List<String> _monthNames = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime.now();
    _odometerController = TextEditingController(
      text: widget.currentOdometer.toString(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month]} ${date.year}';
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final odometerAtService = int.parse(_odometerController.text.trim());

    final costText = _costController.text.trim();
    final int? cost = costText.isEmpty ? null : int.parse(costText);

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiClient.post(
        '${ApiConstants.baseUrl}/vehicles/${widget.vehicleId}/history',
        {
          'reminder_id': widget.reminderId,
          'service_type': widget.serviceType,
          'service_date': _formatDateForApi(_selectedDate),
          'odometer_at_service': odometerAtService,
          'workshop_name': _workshopController.text.trim().isEmpty
              ? null
              : _workshopController.text.trim(),
          'cost': cost,
          'notes': _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan servis berhasil disimpan!'),
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
  void dispose() {
    _odometerController.dispose();
    _workshopController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    Widget? prefixIcon,
    String? suffixText,
    String? hintText,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: AppColors.outline,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.onSurface,
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: Text(
          'Catat Servis',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.surfaceVariant.withValues(alpha: 0.5),
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
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
                    child: Container(color: AppColors.tertiaryContainer),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 16,
                      bottom: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.two_wheeler,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kendaraan',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                widget.vehicleName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jenis Servis',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    enabled: false,
                    initialValue: widget.serviceType,
                    decoration: _inputDecoration(
                      prefixIcon: const Icon(
                        Icons.build,
                        color: AppColors.outline,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Tanggal Servis',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _isLoading ? null : () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _formatDate(_selectedDate),
                        ),
                        decoration: _inputDecoration(
                          prefixIcon: const Icon(
                            Icons.calendar_month,
                            color: AppColors.outline,
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Odometer Saat Servis',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _odometerController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      prefixIcon: const Icon(
                        Icons.speed,
                        color: AppColors.outline,
                      ),
                      suffixText: 'km',
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      final number = int.tryParse(value ?? '');

                      if (number == null) {
                        return 'Odometer harus berupa angka';
                      }

                      if (number < 0) {
                        return 'Odometer tidak boleh negatif';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Tempat Servis',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _workshopController,
                    enabled: !_isLoading,
                    decoration: _inputDecoration(
                      hintText: 'Contoh: Bengkel Pak Budi',
                      prefixIcon: const Icon(
                        Icons.storefront,
                        color: AppColors.outline,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Biaya Servis',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _costController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            'Rp',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.outline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }

                      final number = int.tryParse(value);

                      if (number == null) {
                        return 'Biaya harus berupa angka';
                      }

                      if (number < 0) {
                        return 'Biaya tidak boleh negatif';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Catatan',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Opsional',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.outlineVariant,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _notesController,
                    enabled: !_isLoading,
                    maxLines: 4,
                    decoration: _inputDecoration(
                      hintText: 'Contoh: Ganti oli AHM 10W40',
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
          border: const Border(
            top: BorderSide(color: AppColors.surfaceVariant),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 16,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top: 16,
          left: 20,
          right: 20,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _saveRecord,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimary,
                  ),
                )
              : const Icon(Icons.save, size: 20),
          label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Catatan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
            disabledForegroundColor:
                AppColors.onPrimary.withValues(alpha: 0.8),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            textStyle: theme.textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}