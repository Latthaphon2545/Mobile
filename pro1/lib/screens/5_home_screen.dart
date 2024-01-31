// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro1/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:pro1/provider/auth_provider.dart';

import '2_register_screen.dart';
import '6_booking_screen.dart';
import '8_my_booking.dart';

class HomeScreen extends StatefulWidget {
  // final String uid;
  // const HomeScreen({Key? key, required this.uid});
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String name = '';
  String phone = '';
  String bookCode_A = '';
  String bookCode_B = '';
  String bookCode_C = '';

  @override
  void initState() {
    super.initState();
    getUserData();
    realtimeBookingData();
  }

  void getUserData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('users')
            .where('uid', isEqualTo: ap.userModel.uid)
            .get();
    try {
      setState(() {
        name = userData.docs[0]['name'];
        phone = userData.docs[0]['phoneNumber'];
      });
    } catch (e) {
      showSnackBar(context, 'No user data found!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
        (route) => false,
      );
    }
  }

  void realtimeBookingData() {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseFirestore.collection('booking').snapshots().listen((snapshot) {
      Map<String, int> min = {'A': 0, 'B': 0, 'C': 0};
      for (var doc in snapshot.docs) {
        var bookingCode = doc['bookingCode'];
        String category = bookingCode[0];
        String numberString = bookingCode.substring(1);
        int currentNumber = int.tryParse(numberString) ?? 0;
        min[category] = currentNumber;
      }
      bookCode_A = 'A${min['A']}';
      bookCode_B = 'B${min['B']}';
      bookCode_C = 'C${min['C']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${name}\nPhone: ${phone}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                checkBookinginData();
              },
              child: const Text('Bookings'),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  color: Colors.red,
                  child: Text(
                    '${bookCode_A}',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  color: Colors.yellow,
                  child: Text(
                    '${bookCode_B}',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  color: Colors.green,
                  child: Text(
                    '${bookCode_C}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
            ,const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'My Booking',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyBooking()),
                (route) => false,
              );
              break;
          }
        },
      ),
    );
  }

  void checkBookinginData() async{
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('booking')
            .where('uid', isEqualTo: ap.userModel.uid)
            .get();
    try{
      if (userData.docs[0]['bookingCode'] == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BookingScreen()),
        (route) => false,
      );
    } else {
      showSnackBar(context, 'You already have a queue. If you want to make a new reservation Please cancel the original queue.');
    }
    }catch(e){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BookingScreen()),
        (route) => false,
      );
  }
}
void signOut() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.signOut().then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
            (route) => false,
          ),
        );
  }
}

