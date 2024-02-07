// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Custom/custom_card.dart';

class codeBScreen extends StatefulWidget {
  const codeBScreen({Key? key}) : super(key: key);

  @override
  State<codeBScreen> createState() => _codeBScreenState();
}

class _codeBScreenState extends State<codeBScreen> {
  Timer? _timer;
  Future<QuerySnapshot<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    super.initState();
    _future = getUserBookingData();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _future = getUserBookingData();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getUserBookingData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No user data found.'));
          } else {
            return Center(
              child: Container(
                // for example, half the screen height
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var userData = snapshot.data!.docs[index].data();
                    return ListTile(
                      subtitle: cardWaitlist(
                        userData: userData as Map<String, dynamic>,
                        Screen: const codeBScreen(),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      );

  Future<QuerySnapshot<Map<String, dynamic>>> getUserBookingData() async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    String bookingCode1st = 'B';
    return await _firebaseFirestore
        .collection('booking')
        .where('bookingCode', isGreaterThanOrEqualTo: bookingCode1st)
        .where('bookingCode',
            isLessThan:
                '${bookingCode1st}z') // assuming 'z' comes after possible bookingCode values
        .get();
  }
}
