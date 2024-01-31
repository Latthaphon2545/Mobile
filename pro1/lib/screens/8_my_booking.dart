// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro1/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:pro1/provider/auth_provider.dart';

import '5_home_screen.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  int _currentIndex = 1;
  String name = '';
  String phone = '';
  String bookingCodde = '';
  String bookingDate = '';

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
            .collection('booking')
            .where('uid', isEqualTo: ap.userModel.uid)
            .get();
    try {
      setState(() {
        name = userData.docs[0]['name'];
        phone = userData.docs[0]['phoneNumber'];
        bookingCodde = userData.docs[0]['bookingCode'];
        bookingDate = userData.docs[0]['createdAt'];
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Booking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${name.isNotEmpty ? name : 'not found'}'),
            Text('Phone: ${phone.isNotEmpty ? phone : 'not found'}'),
            Text(
                'Booking Code: ${bookingCodde.isNotEmpty ? bookingCodde : 'not found'}'),
            Text(
                'Booking Date: ${bookingDate.isNotEmpty ? bookingDate : 'not found'}'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content:
                          Text('Are you sure you want to delete the booking?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the alert dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteBooking();
                            Navigator.of(context)
                                .pop(); // Close the alert dialog
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Delete Booking'),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            case 1:
              break;
          }
        },
      ),
    );
  }

  void deleteBooking() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('booking')
            .where('uid', isEqualTo: ap.userModel.uid)
            .get();
    try {
      await _firebaseFirestore
          .collection('booking')
          .doc(userData.docs[0].id)
          .delete();
      showSnackBar(context, 'Delete Booking Success');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyBooking()),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, 'Delete Booking Failed');
    }
  }
}
