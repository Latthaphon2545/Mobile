import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

class mocupCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  // sreen to go variable
  final Widget Screen;
  const mocupCard({super.key, required this.userData, required this.Screen});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(229, 230, 235, 1),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${userData['bookingCode']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color.fromRGBO(237, 37, 78, 1))),
                    Text(' • ${userData['name']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    Text('${userData['numberOfPeople']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Color.fromRGBO(187, 185, 185, 1),
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phone Number'),
                Text('${userData['phoneNumber']}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Booking Time'),
                Text('${userData['createdAt']}'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              onPressed: () {
                alert(
                  context,
                  'Are you sure you want to delete this booking?',
                  () {
                    Delete(context, userData);
                  },
                  Screen,
                );
              },
              text: 'Delete',
              Check: true,
            ),
            CustomButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Screen),
                  (route) => false,
                );
              },
              text: 'Check In',
            ),
          ],
        )
      ]),
    );
  }

  void Delete(BuildContext context, Map<String, dynamic> userData) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    await _firebaseFirestore
        .collection('booking')
        .doc(userData['uid'])
        .delete();

    // await _firebaseFirestore.collection('users').doc(userData['uid']).delete();
  }

  void alert(
      BuildContext context, String message, Function function, Widget Screen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                function();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Screen),
                    (route) => false);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
