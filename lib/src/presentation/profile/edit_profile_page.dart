import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/widgets/moto_bottom_navigation_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Budi Santoso');
  final _phoneController = TextEditingController(text: '0812 3456 7890');
  final _emailController = TextEditingController(
    text: 'budi.santoso@motor.com',
  );
  final _workshopAddressController = TextEditingController(
    text: 'Jl. Merdeka Raya No. 45, Jakarta Selatan',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _workshopAddressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan profil berhasil disimpan!')),
    );
  }

  void _handleBottomNavTap(int index) {
    if (index == 3) {
      Navigator.pop(context);
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DashboardPage(initialIndex: index)),
      (route) => false,
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    int? maxLines,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      hintText: labelText,
      hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: maxLines == null ? 14 : 16,
      ),
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
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profil',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.outlineVariant),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 112,
                                height: 112,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainer,
                                  border: Border.all(
                                    color: AppColors.surfaceContainerLowest,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.06,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: const NetworkImage(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCTouVxoMzexrmQaem1jH2tyzQ2OIjNkR_tPLg8JPCbkcQoSSQlV1OYDWlMkv6baIVDV5xLf30z7f19q-1NE91-ElDnCgftTgEmFje61V6kF9AgueZADYrt_BCB-taUUIcNX1rR_v-CxJJakSYk86qpMS_utMg7kGvRY4c2tT6YO63NGlwaYHlr0y3P2hRC9qwV9rVujwPfhA0W2ehbGggbU_aoWS_TeNtxPQay7r8Z4RTU0RLxzWYpcNntDA3yWKUSUZUdapA5q9kq',
                                    ),
                                    fit: BoxFit.cover,
                                    onError: (_, _) {},
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -4,
                                bottom: -4,
                                child: Material(
                                  color: AppColors.primary,
                                  shape: const CircleBorder(),
                                  elevation: 3,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              AppColors.surfaceContainerLowest,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.photo_camera,
                                        size: 18,
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Format JPG atau PNG (Maks 2MB)',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _ProfileField(
                      label: 'Nama Lengkap',
                      child: TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(
                          labelText: 'Nama Lengkap',
                        ),
                        style: theme.textTheme.bodyMedium,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ProfileField(
                      label: 'Nomor Handphone',
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(
                          labelText: 'Nomor Handphone',
                        ),
                        style: theme.textTheme.bodyMedium,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nomor handphone tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ProfileField(
                      label: 'Email',
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(labelText: 'Email'),
                        style: theme.textTheme.bodyMedium,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@')) {
                            return 'Masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ProfileField(
                      label: 'Alamat Bengkel Langganan',
                      child: TextFormField(
                        controller: _workshopAddressController,
                        maxLines: 3,
                        decoration: _buildInputDecoration(
                          labelText: 'Alamat Bengkel Langganan',
                          maxLines: 3,
                        ),
                        style: theme.textTheme.bodyMedium,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Alamat bengkel tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        textStyle: theme.textTheme.labelLarge,
                      ),
                      child: const Text('Simpan Perubahan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: MotoBottomNavigationBar(
        currentIndex: 3,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
