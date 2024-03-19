// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../Custom/showCupertinoDialog.dart';
import '../main.dart';

class scanQr extends StatefulWidget {
  const scanQr({super.key});

  @override
  State<scanQr> createState() => _scanQrState();
}

class _scanQrState extends State<scanQr> {
  String? lastScannedUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
          controller:
              MobileScannerController(detectionSpeed: DetectionSpeed.normal),
          onDetect: (capture) async {
            final List<Barcode> qrData = capture.barcodes;
            for (final Barcode data in qrData) {
              final String currentUid = data.rawValue.toString();
              if (lastScannedUid == currentUid) {
                continue;
              }
              lastScannedUid = currentUid;
              await _showMyDialog(context, currentUid);
            }
          }),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String uid) async {
      // user data from the database
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await getUserData(uid);

      if (!documentSnapshot.exists) {
        return;
      }

      showMyDialog(
        context: context,
        title: 'Booking',
        content: 'Name: ${documentSnapshot.data()!['name']}\n'
                 'Phone: ${documentSnapshot.data()!['phoneNumber']}',
        actionText: 'Confirm',
        onPressed: () async {
          await saveHistory(context, uid);
          await Delete(context, uid);
        },
      );
  }

  Future<void> Delete(BuildContext context, String uid) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    await _firebaseFirestore.collection('booking').doc(uid).delete();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
      (route) => false,
    );
  }

  Future<void> saveHistory(BuildContext context, String uid) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firebaseFirestore.collection('booking').doc(uid).get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic>? userData = documentSnapshot.data();

      if (userData != null) {
        await _firebaseFirestore.collection('history').add(userData);
      }
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    return await _firebaseFirestore.collection('booking').doc(uid).get();
  }
}
