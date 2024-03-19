import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot<Map<String, dynamic>>> getUserBookingData(
    String bookingCode1st) {
  final StreamController<QuerySnapshot<Map<String, dynamic>>> streamController =
      StreamController<QuerySnapshot<Map<String, dynamic>>>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  _firebaseFirestore
      .collection('booking')
      .where('bookingCode', isGreaterThanOrEqualTo: bookingCode1st)
      .where('bookingCode', isLessThan: '${bookingCode1st}z')
      .snapshots()
      .listen((event) {
    streamController.add(event);
  });

  return streamController.stream;
}
