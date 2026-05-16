import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'widgets/home_tab.dart';
import 'widgets/motor_tab.dart';
import 'widgets/moto_bottom_navigation_bar.dart';
import 'widgets/settings_tab.dart';
import 'widgets/servis_tab.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../profile/edit_profile_page.dart';
import '../../data/services/notification_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late int _currentIndex;

  final NotificationService _notificationService = NotificationService();

  String? get _avatarUrl {
    final metadata = Supabase.instance.client.auth.currentUser?.userMetadata;

    if (metadata == null) return null;

    final avatarUrl = metadata['avatar_url'] ?? metadata['picture'];

    if (avatarUrl == null || avatarUrl.toString().trim().isEmpty) {
      return null;
    }

    return avatarUrl.toString();
  }

  final List<Widget> _tabs = [
    const HomeTab(),
    const MotorTab(),
    const ServisTab(),
    const SettingsTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _notificationService.setupWebPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Row(
          children: [
            const Icon(Icons.motorcycle, color: AppColors.primary, size: 28),
            const SizedBox(width: 8),
            Text(
              'MotoServis',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 8.0),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );

                setState(() {});
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                  border: Border.all(
                    color: AppColors.surfaceContainerHigh,
                    width: 2,
                  ),
                  image: _avatarUrl == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(_avatarUrl!),
                          fit: BoxFit.cover,
                        ),
                ),
                child: _avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 22,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: MotoBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
