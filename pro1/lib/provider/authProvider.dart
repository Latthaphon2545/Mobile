import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro1/models/profile_model.dart';
import 'package:pro1/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/otpScreen.dart';

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
      showSnackBar(context, "Not able to send OTP");
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

      // ignore: unnecessary_null_comparison
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

  void resendOtp(BuildContext context, String phoneNumber) async {
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
            showSnackBar(context, 'Code resent');
          },
          codeAutoRetrievalTimeout: (verificationId) {
            showSnackBar(context, 'Time out');
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // DATABASE OPERATIONS
  Future<bool> checkExitingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(_uid).get();
    if (snapshot.exists) {
      return false;
    } else {
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
    _userModel = UserModel.fromJson(jsonDecode(data));
    notifyListeners();
  }

  void saveBookingDataTofirebasa({
    required BuildContext context,
    required UserModel userModel,
    required Function onSuccess,
  }) async {
    notifyListeners();
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
      userModel.phoneNumber = userModel.phoneNumber;
      userModel.createdAt = formattedDate;
      userModel.uid = userModel.uid;
      await _firebaseFirestore
          .collection("booking")
          .doc(userModel.uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        print('Booking data saved');
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void logout(BuildContext context) async {
    _firebaseAuth.signOut();
    _isSignedIn = false;
    _uid = '';
    _userModel = null;
    // Navigator.pushReplacementNamed(context, '/welcome');
    notifyListeners();
  }

  Future<String> getBookingCode(String Curuid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firebaseFirestore.collection('booking').doc(Curuid).get();
    if (snapshot.exists) {
      String bookindCode = snapshot.data()!['bookingCode'].toString();
      return bookindCode;
    } else {
      return '';
    }
  }

  Stream<Map<String, String>> realtimeBookingData() {
    final StreamController<Map<String, String>> controller =
        StreamController<Map<String, String>>();

    _firebaseFirestore.collection('booking').snapshots().listen((snapshot) {
      Map<String, String> bookingCodes = {};
      Map<String, int> min = {'A': 999, 'B': 999, 'C': 999};

      for (var doc in snapshot.docs) {
        var bookingCode = doc['bookingCode'];
        String category = bookingCode[0];
        String numberString = bookingCode.substring(1);
        int currentNumber = int.tryParse(numberString) ?? 0;
        if (currentNumber < min[category]!) {
          min[category] = currentNumber;
        }
      }

      String bookCode_A = min['A'] == 999 ? 'A0' : 'A${min['A']}';
      String bookCode_B = min['B'] == 999 ? 'B0' : 'B${min['B']}';
      String bookCode_C = min['C'] == 999 ? 'C0' : 'C${min['C']}';

      bookingCodes = {
        'A': bookCode_A,
        'B': bookCode_B,
        'C': bookCode_C,
      };

      controller.add(bookingCodes);
    });
    return controller.stream;
  }

  Stream<String> queueLeft(String char1st) {
    final StreamController<String> controller = StreamController<String>();
    _firebaseFirestore.collection('booking').snapshots().listen((snapshot) {
      int count = 0;
      for (var doc in snapshot.docs) {
        var bookingCode = doc['bookingCode'];
        String category = bookingCode[0];
        if (category == char1st) {
          count++;
        }
      }
      controller.add((count - 1).toString());
    });

    return controller.stream;
  }

  Stream<TableStatus> getRealtimeTable(String childNode) {
    final StreamController<TableStatus> controller =
        StreamController<TableStatus>();
    final databaseReference = FirebaseDatabase.instance.ref();

    databaseReference.onValue.listen((DatabaseEvent event) {
      var data = event.snapshot.value as Map<dynamic, dynamic>;
      var nodes = ['12P', '34P', '58P'];
      for (var node in nodes) {
        var ref = data[node];
        String value = ref['status'];
        int count = ref['people'];
        if (childNode == node) {
          if (value == 'true') {
            controller.add(TableStatus(status: true, peopleCount: count));
          } else if (value == 'false') {
            controller.add(TableStatus(status: false, peopleCount: count));
          }
        }
      }
    });
    return controller.stream;
  }
}

class TableStatus {
  final bool status;
  final int peopleCount;

  TableStatus({required this.status, required this.peopleCount});
}
