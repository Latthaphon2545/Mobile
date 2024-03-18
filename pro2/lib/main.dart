import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:pro2/screen/scanQrCode.dart';
import 'package:pro2/screen/tableStatus.dart';

import 'firebase_options.dart';
import 'screen/waitListScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (error) {
    print("Firebase initialization error: $error");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
          onTab: (value) {
            print(value);
          },
          activeIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Icon(
              Icons.qr_code,
              size: 50,
              color: Color.fromRGBO(255, 88, 88, 0.8),
            ),
          ),
          inActiveIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Colors.white70, shape: BoxShape.circle),
            child: const Icon(
              Icons.qr_code,
              size: 50,
              color: Colors.black45,
            ),
          ),
          text: "Scan QR Code"),
      activeColor: const Color.fromRGBO(255, 88, 88, 0.8),
      navBarBackgroundColor: Colors.white,
      inActiveColor: Colors.black45,
      appBarItems: [
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.list,
              color: Color.fromRGBO(255, 88, 88, 0.8),
            ),
            inActiveIcon: const Icon(
              Icons.home,
              color: Colors.black26,
            ),
            text: 'Waitlist'),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.table_restaurant,
              color: Color.fromRGBO(255, 88, 88, 0.8),
            ),
            inActiveIcon: const Icon(
              Icons.table_restaurant,
              color: Colors.black26,
            ),
            text: 'Table Status'),
      ],
      bodyItems: [
        const waitList(),
        const tableStatusScrren(),
      ],
      actionBarView: const scanQr(),
      extendBody: false,
    );
  }
}
