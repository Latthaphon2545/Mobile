import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'navbar.dart';

class scanQr extends StatefulWidget {
  const scanQr({super.key});

  @override
  State<scanQr> createState() => _scanQrState();
}

class _scanQrState extends State<scanQr> {
  int _selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
          controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates),
          onDetect: (capture) {
            print(capture);
            final List<Barcode> qrData = capture.barcodes;
          }),
      bottomNavigationBar: navBarBottom(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
