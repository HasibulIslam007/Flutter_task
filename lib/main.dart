import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'helpers/notification_service.dart';
import 'features/onboarding_screen.dart';

Future<void> requestNotificationPermission() async {

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();         // Initializes flutter_local_notifications
  await requestNotificationPermission();          //  Requests POST_NOTIFICATIONS on Android 13+
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Alarm App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: OnboardingScreen(),
    );
  }
}
