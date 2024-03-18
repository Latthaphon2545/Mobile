// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pro1/provider/authProvider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../util/utils.dart';

class QRCode extends StatelessWidget {
  final String data;
  const QRCode({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: _firebaseFirestore
          .collection('booking')
          .doc(ap.userModel.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (!snapshot.data!.exists) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showSnackBar(context, 'Successful');
            Navigator.pushNamedAndRemoveUntil(
                context, '/homeScrenn', (route) => false);
          });
        }

        return Scaffold(
            appBar: AppBar(
              title: const Text('QR Code'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      color: Colors.white,
                      child: QrImageView(
                        data: data,
                        version: QrVersions.auto,
                        size: 320,
                      )),
                ],
              ),
            ));
      },
    );
  }
}
