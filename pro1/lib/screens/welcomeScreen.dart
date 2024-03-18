import 'package:flutter/material.dart';
import 'package:pro1/provider/authProvider.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the app!!!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Countdown(
                  seconds: 1,
                  build: (BuildContext context, double time) => const Text(''),
                  interval: const Duration(milliseconds: 100),
                  onFinished: () async {
                    if (ap.isSignedIn == false) {
                      Navigator.pushNamed(context, '/RegisterScreen');
                    } else {
                      await ap.getUserDataFromSP().whenComplete(
                            () => Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/homeScrenn',
                              (route) => false,
                            ),
                          );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
