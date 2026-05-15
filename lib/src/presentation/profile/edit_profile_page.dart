import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _workshopAddressController = TextEditingController();

  bool _isLoading = false;

  User? get _user => Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();

    final user = _user;
    final metadata = user?.userMetadata ?? {};

    _nameController.text =
        metadata['full_name']?.toString() ??
        metadata['name']?.toString() ??
        '';

    _phoneController.text = metadata['phone']?.toString() ?? '';

    _emailController.text = user?.email ?? '';

    _workshopAddressController.text =
        metadata['workshop_address']?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _workshopAddressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'workshop_address': _workshopAddressController.text.trim(),
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perubahan profil berhasil disimpan!'),
        ),
      );

      Navigator.pop(context, true);
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan profil, coba lagi'),
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

    final avatarUrl = _user?.userMetadata?['avatar_url'] ??
        _user?.userMetadata?['picture'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                                  image: avatarUrl == null
                                      ? null
                                      : DecorationImage(
                                          image: NetworkImage(
                                            avatarUrl.toString(),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                child: avatarUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 52,
                                        color: AppColors.primary,
                                      )
                                    : null,
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
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Upload foto profil belum diaktifkan.',
                                          ),
                                        ),
                                      );
                                    },
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
                            'Tambahkan foto profil Anda.',
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
                        enabled: !_isLoading,
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
                        enabled: !_isLoading,
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(
                          labelText: 'Nomor Handphone',
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _ProfileField(
                      label: 'Email',
                      child: TextFormField(
                        controller: _emailController,
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(labelText: 'Email'),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(height: 16),

                    _ProfileField(
                      label: 'Alamat Bengkel Langganan',
                      child: TextFormField(
                        controller: _workshopAddressController,
                        enabled: !_isLoading,
                        maxLines: 3,
                        decoration: _buildInputDecoration(
                          labelText: 'Alamat Bengkel Langganan',
                          maxLines: 3,
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
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
                        textStyle: theme.textTheme.labelLarge,
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
                          : const Text('Simpan Perubahan'),
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