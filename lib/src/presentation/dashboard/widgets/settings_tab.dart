import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../profile/edit_profile_page.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _pushNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileCard(theme: theme),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'PENGATURAN',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsGroup(
            children: [
              _SettingsMenuItem(
                icon: Icons.person_outline,
                label: 'Detail Profil',
                onTap: () {},
              ),
              _SettingsMenuItem(
                icon: Icons.lock_outline,
                label: 'Password',
                onTap: () {},
              ),
              _SettingsSwitchItem(
                icon: Icons.notifications_outlined,
                label: 'Push Notification',
                value: _pushNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _pushNotificationsEnabled = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: theme.textTheme.labelLarge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 52),
            ),
            child: const Text('Keluar'),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                textStyle: theme.textTheme.bodyMedium,
              ),
              child: const Text('Hapus Akun Saya'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 560;

          final profileInfo = Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                  image: DecorationImage(
                    image: const NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDqQPU6H6Jh4cONGr6oQN0BTnuuqx9Vf8u8dO2ZAwLRQVrVGnCF6Fu_4p7zoQbUhJ-Q1ooMLleOA9p_tHpPm4QCFnJyagnCu7xk7qtgoNaQx5xj3U7k-kUwiM4FhTmm4EXgbBmGWJsKwbrQF9XyNI3zIzSlqf7he5-EJAWISTpNY9avT_glv6MdeiQnMcgIYJ7MPuoJa4yi4LSYiXh-pEAhKtewdcyYKQvmF7NBNde5BoIEWs5Z0b_BFhEN-zEHYwVjJQn2mLZVe1IB',
                    ),
                    fit: BoxFit.cover,
                    onError: (_, _) {},
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budi Santoso',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'budi@email.com',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final editButton = ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: theme.textTheme.labelLarge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(isWide ? 0 : double.infinity, 44),
            ),
            child: const Text('Edit Profil'),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(child: profileInfo),
                const SizedBox(width: 16),
                editButton,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [profileInfo, const SizedBox(height: 16), editButton],
          );
        },
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (index, child) in children.indexed) ...[
            if (index > 0)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.outlineVariant,
              ),
            child,
          ],
        ],
      ),
    );
  }
}

class _SettingsMenuItem extends StatelessWidget {
  const _SettingsMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitchItem extends StatelessWidget {
  const _SettingsSwitchItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.onSecondary,
            activeTrackColor: AppColors.secondaryContainer,
            inactiveThumbColor: AppColors.surfaceContainerLowest,
            inactiveTrackColor: AppColors.surfaceVariant,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
