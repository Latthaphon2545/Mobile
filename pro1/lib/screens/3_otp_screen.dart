import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:pro1/screens/5_home_screen.dart';
import 'package:pro1/screens/4_user_Infomation.dart';
import '../provider/auth_provider.dart';
import '../util/utils.dart';
import 'package:provider/provider.dart';

import '../util/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  const OtpScreen(
      {super.key, required this.verificationId, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Screen'),
      ),
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.purple,
              ))
            : Center(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          //  color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onCompleted: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CoutomButton(
                          text: 'Verify',
                          onPressed: () {
                            if (otpCode != null) {
                              verifyOtp(context, otpCode!);
                            } else {
                              showSnackBar(context, 'Please 6-Digit Code');
                            }
                          },
                        )),
                    const SizedBox(height: 20),
                    const Text('Didn\'t receive the code?',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    const Text('Resend Code',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: (uid) {
          ap.checkExitingUser().then((value) async {
            if (value == false) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => UserInfomationScreen(
                      //       uidCur: uid,)),
                      builder: (context) => UserInfomationScreen()),
                  (route) => false);
            }
          });
        });
  }
}
