import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';
import 'showCupertinoDialog.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class cardWaitlist extends StatelessWidget {
  final Map<String, dynamic> userData;
  // sreen to go variable
  final Widget Screen;
  const cardWaitlist({super.key, required this.userData, required this.Screen});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(229, 230, 235, 1),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 7),
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
                    const Icon(
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
                const Text('Phone Number'),
                TextButton(
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(
                          '${userData['phoneNumber']}');
                    },
                    child: Text('${userData['phoneNumber']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 0, 0, 1))))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Booking Time'),
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
                showMyDialog(
                  context: context,
                  title: 'Delete Booking',
                  content:
                      'Name: ${userData['name']}\nPhone: ${userData['phoneNumber']}',
                  actionText: 'Confirm',
                  onPressed: () async {
                    Delete(context, userData);
                  },
                );
              },
              text: 'Delete',
              Check: true,
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
  }
}

class cardHistory extends StatelessWidget {
  final Map<String, dynamic> userData;
  const cardHistory({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(229, 230, 235, 1),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 7),
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
                    const Icon(
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
                const Text('Phone Number'),
                Text('${userData['phoneNumber']}'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Booking Time'),
                Text('${userData['createdAt']}'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}
