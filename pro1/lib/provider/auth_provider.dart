import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro1/models/profile_model.dart';
import 'package:pro1/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/3_otp_screen.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  bool isBooking = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool('is_SignedIn') ?? false;
    notifyListeners();
  }

  Future setSingIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool('is_SignedIn', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (erroe) {
            throw Exception(erroe.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpScreen(
                          verificationId: verificationId,
                          phone: phoneNumber,
                        )));
          },
          codeAutoRetrievalTimeout: (verificationId) {
            showSnackBar(context, 'Time out');
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      if (user != null) {
        _uid = user.uid;
        onSuccess(_uid);
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERATIONS
  Future<bool> checkExitingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(_uid).get();
    if (snapshot.exists) {
      // print('User already exists');
      return false;
    } else {
      // print('User does not exists');
      return false;
    }
  }

  void saveUserDataTofirebasa({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
    try {
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      userModel.createdAt = formattedDate;
      userModel.uid = _firebaseAuth.currentUser!.uid;
      // upload
      _userModel = userModel;
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      showSnackBar(context, e.message.toString());
    }
  }

  // Storing data locally
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('user_model', jsonEncode(_userModel!.toMap()));
  }

  Future getUserDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String? data = s.getString('user_model') ?? '';
    _userModel = UserModel.fromJson(jsonDecode(data!));
    notifyListeners();
  }

  void saveBookingDataTofirebasa({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      userModel.createdAt = formattedDate;
      userModel.uid = _firebaseAuth.currentUser!.uid;
      await _firebaseFirestore
          .collection("booking")
          .doc(userModel.uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        isBooking = true;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      showSnackBar(context, e.message.toString());
    }
  }

  Future<bool> signOut() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.clear();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    return true;
  }
}
