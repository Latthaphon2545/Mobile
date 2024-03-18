import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/homeScreen.dart';
import 'screens/myBooking.dart';
import 'screens/registerScreen.dart';
import 'screens/userInfomation.dart';
import 'screens/welcomeScreen.dart';
import 'provider/authProvider.dart';
import 'firebase_options.dart';

import './provider/noti.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAPI().initNotification();
  } catch (error) {
    debugPrint("Firebase initialization error: $error");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        // Removed 'const' here
        debugShowCheckedModeBanner: false,
        title: _title,
        home: const Scaffold(
          body: Center(
            child: WelcomeScreen(),
          ),
        ),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/RegisterScreen': (context) => const RegisterScreen(),
          '/homeScrenn': (context) => const HomeScreen(),
          '/myBooking': (context) => const MyBooking(),
          '/userInfomation': (context) => UserInfomationScreen(),
        },
      ),
    );
  }
}
