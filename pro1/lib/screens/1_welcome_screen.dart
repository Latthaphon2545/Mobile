import 'package:flutter/material.dart';
import 'package:pro1/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../util/custom_button.dart';
import '2_register_screen.dart';
import '5_home_screen.dart';

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
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CoutomButton(
                    text: 'Get Started',
                    onPressed: () async {
                      if (ap.isSignedIn ==  false){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen()));
                      }else{
                        await ap.getUserDataFromSP().whenComplete(() =>
                         Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen())
                                    , (route) => false,));
                      }// Use the correct route name
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
