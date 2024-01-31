// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'a.dart';
import 'b.dart';

class cScreen extends StatefulWidget {
  const cScreen({Key? key}) : super(key: key);

  @override
  State<cScreen> createState() => _cScreenState();
}

class _cScreenState extends State<cScreen> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C Code'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                  title: Text('Name: ${userData['name']}'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone Number: ${userData['phoneNumber']}'),
                          Text('Booking Code: ${userData['bookingCode']}'),
                          Text('Created At: ${userData['createdAt']}'),
                        ],
                      ),
                      // icon trash
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red, // Set the color to red
                        ),
                        onPressed: () async {
                          final FirebaseFirestore _firebaseFirestore =
                              FirebaseFirestore.instance;
                          await _firebaseFirestore
                              .collection('booking')
                              .doc(userData['uid'])
                              .delete();

                          await _firebaseFirestore
                              .collection('users')
                              .doc(userData['uid'])
                              .delete();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const cScreen()),
                            (route) => false,
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Text('A'),
            label: 'Code',
          ),
          BottomNavigationBarItem(
            icon: Text('B'),
            label: 'Code',
          ),
          BottomNavigationBarItem(
            icon: Text('C'),
            label: 'Code',
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
                MaterialPageRoute(builder: (context) => const aScreen()),
                (route) => false,
              );
              break;
            case 1:
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const bScreen()),
                (route) => false,
              );
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserBookingData() async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    String bookingCode1st = 'C';
    return await _firebaseFirestore
        .collection('booking')
        .where('bookingCode', isGreaterThanOrEqualTo: bookingCode1st)
        .where('bookingCode',
            isLessThan: bookingCode1st +
                'z') // assuming 'z' comes after possible bookingCode values
        .get();
  }
}
