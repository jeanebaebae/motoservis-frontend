import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'widgets/home_tab.dart';
import 'widgets/motor_tab.dart';
import 'widgets/servis_tab.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const MotorTab(),
    const ServisTab(),
    const Center(child: Text('Setting')),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications, color: AppColors.onSurfaceVariant),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 8.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainer,
                border: Border.all(color: AppColors.surfaceContainerHigh, width: 2),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA73e2YOpEzYGqpKu3nqB5DN3bmA1oty-RVF41aoo4JWzGcaHT9STQLJUbNyiSvJH2Gf4g3Q3VRd1vIeNVgL1eLbjBv1tL5dLoFpPdhtSQk_-AL-IOZtBi8rowZ4lfcvaGj-EmnxFisMwxmTZncjDgO3ZRzFR6-l0fBs8D23ItNuw9bNIbRUw_4FMNxHOcgEbPM7yg5etMKhedG8yLnd_4LDb8JjQ-wUdDHWLzmngD0WY8OKQZG4d-OkAATPJqADnwlBO84rlJHMNIY',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_component_outlined),
              activeIcon: Icon(Icons.settings_input_component),
              label: 'Motor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Servis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
