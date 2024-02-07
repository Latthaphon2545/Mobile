// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Custom/custom_card.dart';

class codeCScreen extends StatefulWidget {
  const codeCScreen({Key? key}) : super(key: key);

  @override
  State<codeCScreen> createState() => _codeCScreenState();
}

class _codeCScreenState extends State<codeCScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getUserBookingData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No user data found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userData = snapshot.data!.docs[index].data();
              return ListTile(
                subtitle: mocupCard(
                  userData: userData as Map<String, dynamic>,
                  Screen: const codeCScreen(),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserBookingData() async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    String bookingCode1st = 'C';
    return await _firebaseFirestore
        .collection('booking')
        .where('bookingCode', isGreaterThanOrEqualTo: bookingCode1st)
        .where('bookingCode',
            isLessThan:
                '${bookingCode1st}z') // assuming 'z' comes after possible bookingCode values
        .get();
  }
}
