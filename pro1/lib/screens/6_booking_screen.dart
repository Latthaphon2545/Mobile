import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro1/screens/5_home_screen.dart';
import 'package:pro1/screens/8_my_booking.dart';
import 'package:provider/provider.dart';

import '../models/profile_model.dart';
import '../provider/auth_provider.dart';
import '../util/utils.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? _selectedNumber;
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(title: Text(f.format(DateTime.now()))),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('How many people?:'),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: const Text('Many people?'),
                  isExpanded: true,
                  items: <String>['1', '2', '3', '4'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedNumber = value;
                    });
                  },
                  value: _selectedNumber,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                storeData();
              },
              child: const Text('+'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> runbookingCode(String _selected) async {
    String bookingCode1st = '';
    if (_selected == '1' || _selected == '2') {
      bookingCode1st = 'A';
    } else if (_selected == '3') {
      bookingCode1st = 'B';
    } else if (_selected == '4') {
      bookingCode1st = 'C';
    }
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('booking')
            .where('bookingCode', isGreaterThanOrEqualTo: bookingCode1st)
            .where('bookingCode',
                isLessThan: bookingCode1st +
                    'z') // assuming 'z' comes after possible bookingCode values
            .get();
    int numberOfBookings = userData.docs.length + 1;
    String bookingCode = bookingCode1st + numberOfBookings.toString();

    // Corrected the return statement
    return bookingCode;
  }

  void storeData() async {
    String bookCode = await runbookingCode(_selectedNumber!);
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: ap.userModel.name,
      phoneNumber: ap.userModel.phoneNumber,
      createdAt: '',
      uid: ap.userModel.uid,
      bookingCode: bookCode,
    );
    if (_selectedNumber != null) {
      // ignore: use_build_context_synchronously
      ap.saveBookingDataTofirebasa(
          context: context,
          userModel: userModel,
          onSuccess: () {
            showSnackBar(context, 'Booking Success');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyBooking()),
                (route) => false);
          });
    } else {
      showSnackBar(context, 'กรุณาเลือกจำนวนคน');
    }
  }
}
