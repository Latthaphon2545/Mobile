import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../util/custom_button.dart';

class QRCode extends StatelessWidget {
  final String data;
  const QRCode({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const SizedBox(
            height: 20,
          ),
          CustomButton(
              text: 'Back',
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    ));
  }
}
