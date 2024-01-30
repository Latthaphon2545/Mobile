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
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'No user data found!');
      // ignore: use_build_context_synchronously
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
      Map<String, int> maxNumbers = {'A': 0, 'B': 0, 'C': 0};
      for (var doc in snapshot.docs) {
        var bookingCode = doc['bookingCode'];
        String category = bookingCode[0]; 
        String numberString = bookingCode.substring(1);
        int currentNumber = int.tryParse(numberString) ?? 0;
        if (currentNumber > maxNumbers[category]!) {
          maxNumbers[category] = currentNumber;
        }
      }
      setState(() {
        bookCode_A = 'A${maxNumbers['A']}';
        bookCode_B = 'B${maxNumbers['B']}';
        bookCode_C = 'C${maxNumbers['C']}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    realtimeBookingData();
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Information:\nName: ${name}\nPhone: ${phone}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookingScreen()));
              },
              child: const Text('Bookings'),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${bookCode_A}'),
                Text('${bookCode_B}'),
                Text('${bookCode_C}'),
              ],
            )
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
                MaterialPageRoute(builder: (context) => MyBooking()),
                (route) => false,
              );
              break;
          }
        },
      ),
    );
  }
}

