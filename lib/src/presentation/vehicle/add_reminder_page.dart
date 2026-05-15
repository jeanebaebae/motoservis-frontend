import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../core/theme/app_colors.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({
    super.key,
    required this.vehicleId,
    required this.currentOdometer,
  });

  final String vehicleId;
  final dynamic currentOdometer;

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiClient _apiClient = ApiClient();

  String? _selectedServiceType;

  final TextEditingController _customServiceTypeController =
      TextEditingController();

  final TextEditingController _intervalController =
      TextEditingController(text: '2000');

  late final TextEditingController _lastKmController;

  final TextEditingController _notifyBeforeController =
      TextEditingController(text: '200');

  bool _isLoading = false;

  final List<String> _serviceTypes = [
    'Oli Mesin',
    'Filter Udara',
    'Oli Gardan',
    'Rantai',
    'Kampas Rem',
    'Busi',
    'Ban',
    'Aki',
    'CVT',
    'Shockbreaker',
    'Lainnya',
  ];

  int get _currentOdometer {
    return int.tryParse(widget.currentOdometer.toString()) ?? 0;
  }

  int _calculateTarget() {
    final interval = int.tryParse(_intervalController.text.trim()) ?? 0;
    final lastKm = int.tryParse(_lastKmController.text.trim()) ?? 0;
    return lastKm + interval;
  }

  String _formatKm(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _lastKmController = TextEditingController(
      text: _currentOdometer.toString(),
    );

    _intervalController.addListener(_onInputChanged);
    _lastKmController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _intervalController.removeListener(_onInputChanged);
    _lastKmController.removeListener(_onInputChanged);

    _customServiceTypeController.dispose();
    _intervalController.dispose();
    _lastKmController.dispose();
    _notifyBeforeController.dispose();

    super.dispose();
  }

  InputDecoration _inputDecoration({
    String? hintText,
    bool showKmSuffix = false,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      hintText: hintText,
      suffixText: showKmSuffix ? 'km' : null,
      suffixStyle: const TextStyle(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
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

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;

    final intervalKm = int.parse(_intervalController.text.trim());
    final lastServiceKm = int.parse(_lastKmController.text.trim());
    final notifyBeforeKm = int.parse(_notifyBeforeController.text.trim());

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiClient.post(
        '${ApiConstants.baseUrl}/vehicles/${widget.vehicleId}/reminders',
        {
          'service_type': _selectedServiceType,
          if (_selectedServiceType == 'Lainnya')
            'custom_service_type': _customServiceTypeController.text.trim(),
          'interval_km': intervalKm,
          'last_service_km': lastServiceKm,
          'notify_before_km': notifyBeforeKm,
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder berhasil disimpan!'),
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

    final interval = int.tryParse(_intervalController.text.trim()) ?? 0;
    final lastKm = int.tryParse(_lastKmController.text.trim()) ?? 0;
    final targetKm = _calculateTarget();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.onSurface,
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Reminder',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
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
                  DropdownButtonFormField<String>(
                    value: _selectedServiceType,
                    icon: const Icon(
                      Icons.expand_more,
                      color: AppColors.outline,
                    ),
                    decoration: _inputDecoration(
                      hintText: 'Pilih jenis...',
                    ),
                    items: _serviceTypes.map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _selectedServiceType = value;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih jenis servis';
                      }
                      return null;
                    },
                  ),

                  if (_selectedServiceType == 'Lainnya') ...[
                    const SizedBox(height: 16),
                    Text(
                      'Jenis Servis Custom',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _customServiceTypeController,
                      enabled: !_isLoading,
                      decoration: _inputDecoration(
                        hintText: 'Contoh: Servis CVT',
                      ),
                      validator: (value) {
                        if (_selectedServiceType == 'Lainnya' &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Jenis servis custom wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 16),

                  Text(
                    'Interval Servis',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _intervalController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      showKmSuffix: true,
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      final number = int.tryParse(value ?? '');

                      if (number == null) {
                        return 'Interval servis harus angka';
                      }

                      if (number <= 0) {
                        return 'Interval servis harus lebih dari 0';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'KM Servis Terakhir',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _lastKmController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      showKmSuffix: true,
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      final number = int.tryParse(value ?? '');

                      if (number == null) {
                        return 'KM servis terakhir harus angka';
                      }

                      if (number < 0) {
                        return 'KM servis terakhir tidak boleh negatif';
                      }

                      if (number > _currentOdometer) {
                        return 'KM servis terakhir tidak boleh lebih besar dari odometer sekarang';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Notifikasi Sebelum',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _notifyBeforeController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      showKmSuffix: true,
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      final number = int.tryParse(value ?? '');

                      if (number == null) {
                        return 'Notifikasi sebelum harus angka';
                      }

                      if (number < 0) {
                        return 'Notifikasi sebelum tidak boleh negatif';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calculate,
                            color: AppColors.onPrimaryFixed,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target KM Otomatis',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.end,
                                spacing: 8,
                                children: [
                                  Text(
                                    _formatKm(lastKm),
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    '+ ${_formatKm(interval)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  Text(
                                    '=',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: _formatKm(targetKm),
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' km',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.6),
                      disabledForegroundColor:
                          AppColors.onPrimary.withValues(alpha: 0.8),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : Text(
                            'Simpan Reminder',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}