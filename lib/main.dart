import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/presentation/core/theme/app_theme.dart';
import 'src/presentation/onboarding/onboarding_page.dart';
import 'src/presentation/dashboard/dashboard_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  
  await Supabase.initialize(
    url: 'https://urqcxgcvmkaepukryimf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVycWN4Z2N2bWthZXB1a3J5aW1mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3MjY1MDQsImV4cCI6MjA5NDMwMjUwNH0.rouqd9TavMDhj02-ziHg50dpypwZHw9w4DLKX16PTFs',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'MotoServis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: session == null ? const OnboardingPage() : const DashboardPage(),
    );
  }
}