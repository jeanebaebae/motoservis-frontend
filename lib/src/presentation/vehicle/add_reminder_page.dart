import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedServiceType;
  final TextEditingController _intervalController = TextEditingController(text: '2000');
  final TextEditingController _lastKmController = TextEditingController(text: '11000');
  final TextEditingController _notifyBeforeController = TextEditingController(text: '200');

  final List<String> _serviceTypes = [
    'Oli Mesin',
    'Filter Udara',
    'Busi',
    'Kampas Rem',
  ];

  int _calculateTarget() {
    final interval = int.tryParse(_intervalController.text) ?? 0;
    final lastKm = int.tryParse(_lastKmController.text) ?? 0;
    return lastKm + interval;
  }

  void _onInputChanged() {
    setState(() {}); // Trigger rebuild to update calculation
  }

  @override
  void initState() {
    super.initState();
    _intervalController.addListener(_onInputChanged);
    _lastKmController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _intervalController.removeListener(_onInputChanged);
    _lastKmController.removeListener(_onInputChanged);
    _intervalController.dispose();
    _lastKmController.dispose();
    _notifyBeforeController.dispose();
    super.dispose();
  }

  void _saveReminder() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder berhasil disimpan!')),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildSuffixKm(ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(left: BorderSide(color: AppColors.outlineVariant)),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'km',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetKm = _calculateTarget();
    final interval = int.tryParse(_intervalController.text) ?? 0;
    final lastKm = int.tryParse(_lastKmController.text) ?? 0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.onSurface,
          onPressed: () => Navigator.pop(context),
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
        padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis Servis
                  Text('Jenis Servis', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedServiceType,
                    icon: const Icon(Icons.expand_more, color: AppColors.outline),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      hintText: 'Pilih jenis...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    ),
                    items: _serviceTypes.map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type, style: theme.textTheme.bodyMedium),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedServiceType = value;
                      });
                    },
                    validator: (value) => value == null ? 'Pilih jenis servis' : null,
                  ),
                  const SizedBox(height: 16),

                  // Interval Servis
                  Text('Interval Servis', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _intervalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      suffixIcon: _buildSuffixKm(theme),
                      contentPadding: const EdgeInsets.only(left: 16),
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
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Masukkan interval servis';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // KM Servis Terakhir
                  Text('KM Servis Terakhir', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _lastKmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      suffixIcon: _buildSuffixKm(theme),
                      contentPadding: const EdgeInsets.only(left: 16),
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
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Masukkan KM servis terakhir';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notifikasi Sebelum
                  Text('Notifikasi Sebelum', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _notifyBeforeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      suffixIcon: _buildSuffixKm(theme),
                      contentPadding: const EdgeInsets.only(left: 16),
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
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Masukkan notifikasi sebelum';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Calculation Component
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
                          child: const Icon(Icons.calculate, color: AppColors.onPrimaryFixed),
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
                                    lastKm.toString(),
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    '+ ${interval.toString()}',
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
                                          text: targetKm.toString(),
                                          style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' km',
                                          style: theme.textTheme.labelMedium?.copyWith(
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

                  // Primary Action Button
                  ElevatedButton(
                    onPressed: _saveReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
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
