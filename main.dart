import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/push_notification_service.dart';
import 'services/usage_service.dart';
import 'services/scheduler_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SchedulerService.initialize(); // Initialize the scheduler
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UsageService>(create: (_) => UsageService()),
        Provider<PushNotificationService>(create: (_) => PushNotificationService()),
      ],
      child: MaterialApp(
        title: 'Screen Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
