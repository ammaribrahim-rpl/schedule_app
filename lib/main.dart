import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'providers/schedule_provider.dart';
import 'theme/app_theme.dart';
import 'auth/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: Consumer<ScheduleProvider>(
        builder: (context, scheduleProvider, child) {
          return MaterialApp(
            title: 'Schedule App Generator',
            debugShowCheckedModeBanner: false,
            themeMode: scheduleProvider.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    backgroundColor:
                        scheduleProvider.themeMode == ThemeMode.dark
                            ? const Color(0xFF131B2E)
                            : const Color(0xFFF5F0E8),
                    body: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheduleProvider.themeMode == ThemeMode.dark
                              ? const Color(0xFFC9A84C)
                              : const Color(0xFF2D4A3E),
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return const HomeScreen();
                }
                return const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}