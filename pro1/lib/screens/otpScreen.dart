// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../provider/authProvider.dart';
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
        title: const Text('OTP'),
        // color of the appbar
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.purple,
              ))
            : Container(
                color: Colors.white,
                child: Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('An SMS code was sent to'),
                      const SizedBox(height: 5),
                      Text(
                        widget.phone,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
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
                          child: CustomButton(
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
                      ElevatedButton(
                        onPressed: () {
                          resentOtp();
                        },
                        child: const Text(
                          'Resend code',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                        ),
                      )
                    ],
                  ),
                )),
              ),
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
              Navigator.pushNamedAndRemoveUntil(
                  context, '/userInfomation', (route) => false);
            }
          });
        });
  }

  void resentOtp() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.resendOtp(context, widget.phone);
  }
}
