import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class RecordServicePage extends StatefulWidget {
  const RecordServicePage({super.key});

  @override
  State<RecordServicePage> createState() => _RecordServicePageState();
}

class _RecordServicePageState extends State<RecordServicePage> {
  final _formKey = GlobalKey<FormState>();

  String _selectedServiceType = 'Oli Mesin';
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _odometerController = TextEditingController(text: '12450');
  final TextEditingController _costController = TextEditingController(text: '85000');
  final TextEditingController _notesController = TextEditingController(text: 'Bengkel Pak Budi, ganti oli AHM 10W40');

  final List<String> _serviceTypes = [
    'Oli Mesin',
    'Oli Gardan',
    'Filter Udara',
    'CVT',
    'V-Belt',
    'Kampas Rem',
    'Roller'
  ];

  final List<String> _monthNames = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month]} ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Saved: $_selectedServiceType, ${_formatDate(_selectedDate)}, ${_odometerController.text}, ${_costController.text}, ${_notesController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan servis berhasil disimpan!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
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
        padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 40),
        child: Column(
          children: [
            // Context Card: Vehicle Information
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
                  // Left Accent Bar
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 4,
                    child: Container(color: AppColors.tertiaryContainer),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.two_wheeler, color: AppColors.onSurfaceVariant),
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
                                'Vario 160 Harian',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz, color: AppColors.primary),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Service Log Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis Servis
                  Text('Jenis Servis', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedServiceType,
                    icon: const Icon(Icons.expand_more, color: AppColors.outline),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      prefixIcon: const Icon(Icons.build, color: AppColors.outline),
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
                    ),
                    items: _serviceTypes.map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type, style: theme.textTheme.bodyMedium),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) _selectedServiceType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Servis
                  Text('Tanggal Servis', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(text: _formatDate(_selectedDate)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceContainerLowest,
                          prefixIcon: const Icon(Icons.calendar_month, color: AppColors.outline),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Odometer
                  Text('Odometer Saat Servis', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _odometerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      prefixIcon: const Icon(Icons.speed, color: AppColors.outline),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('km', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outline)),
                          ],
                        ),
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
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Biaya Servis
                  Text('Biaya Servis', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Rp', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.outline, fontWeight: FontWeight.w500)),
                          ],
                        ),
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
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Catatan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Catatan', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                      Text('Opsional', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.outlineVariant, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      contentPadding: const EdgeInsets.all(16),
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
          border: Border(top: BorderSide(color: AppColors.surfaceVariant)),
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
          onPressed: _saveRecord,
          icon: const Icon(Icons.save, size: 20),
          label: const Text('Simpan Catatan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
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
