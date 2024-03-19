// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro1/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:pro1/provider/authProvider.dart';

import '../util/navigation.dart';
import '../util/custom_button.dart';
import '../util/showCupertinoDialog.dart';
import 'qrCode.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  int _currentIndex = 1;
  String uid = '';
  String name = '';
  String phone = '';
  String bookingCodde = '';
  String bookingDate = '';
  String numberOfPeople = '';

  @override
  void initState() {
    super.initState();
    getBookingData();
  }

  void getBookingData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('booking')
            .where('uid', isEqualTo: ap.userModel.uid)
            .get();
    try {
      if (userData.docs.isNotEmpty) {
        setState(() {
          name = userData.docs[0]['name'];
          phone = userData.docs[0]['phoneNumber'];
          bookingCodde = userData.docs[0]['bookingCode'];
          bookingDate = userData.docs[0]['createdAt'];
          numberOfPeople = userData.docs[0]['numberOfPeople'];
          uid = userData.docs[0]['uid'];
        });
      } else {
        print('No user data found!');
        setState(() {
          name = '';
          phone = '';
          bookingCodde = '';
          bookingDate = '';
          numberOfPeople = '';
          uid = '';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Booking'),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: const Color.fromRGBO(237, 37, 78, 1),
              height: 1.0,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                showMyDialog(
                  context: context,
                  title: 'Logout',
                  content: 'Are you sure you want to logout?',
                  actionText: 'Logout',
                  onPressed: () async {
                    ap.logout(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/RegisterScreen',
                      (route) => false,
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Center(child: Builder(builder: (context) {
            if (bookingCodde != "") {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: const EdgeInsets.all(20),
                  color: const Color.fromRGBO(231, 233, 232, 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 50,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                phone,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(59, 0, 0, 0),
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('No.'),
                                  Text('\t\t$bookingCodde',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                          const Text('|',
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w100,
                                  color: Color.fromARGB(59, 0, 0, 0))),
                          Container(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Waiting List'),
                                  StreamBuilder<String>(
                                    stream: ap.queueLeft(bookingCodde[0]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        String queueLeft = snapshot.data!;
                                        if (int.parse(queueLeft) < 0) {
                                          getBookingData();
                                        }
                                        return Text(
                                          '\t\t$queueLeft',
                                          style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        return const Text('No data available.');
                                      }
                                    },
                                  ),
                                ],
                              )),
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(59, 0, 0, 0),
                        height: 0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(bookingDate.substring(0, 11))
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(bookingDate.substring(10)),
                              ],
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Seat Quantities :'),
                          Text('$numberOfPeople  People')
                        ],
                      ),
                      const Text('** 1 table for 1 phone number **',
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                      Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QRCode(
                                      // uid
                                      data: uid,
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.qr_code,
                                size: 70,
                                color: Color.fromRGBO(0, 0, 0, 1),
                                shadows: [
                                  Shadow(
                                    blurRadius: 7.0,
                                    color: Color.fromARGB(255, 88, 88, 88),
                                    offset: Offset(
                                      3,
                                      3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Show QR code to staff',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Color.fromARGB(59, 0, 0, 0),
                        height: 0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Center(
                              child: bookingCodde.isNotEmpty
                                  ? CustomButton(
                                      onPressed: () {
                                        showMyDialog(
                                            context: context,
                                            title: 'Cancel Booking',
                                            content:
                                                'Are you sure you want to cancel booking?',
                                            actionText: 'Yes',
                                            onPressed: () => deleteBooking());
                                      },
                                      text: 'Cancel',
                                    )
                                  : const SizedBox()),
                        ],
                      ),
                    ],
                  ));
            } else {
              return Center(
                  child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                color: const Color.fromRGBO(231, 233, 232, 1),
                alignment: Alignment.center,
                child: const Text(
                  'No Booking',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ));
            }
          })),
        ),
        bottomNavigationBar: navBarBottom(
          currentIndex: _currentIndex,
        ));
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
      getBookingData();
      Navigator.of(context).pop();
    } catch (e) {
      showSnackBar(context, 'Delete Booking Failed');
    }
  }
}
