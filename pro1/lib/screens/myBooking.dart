// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro1/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:pro1/provider/authProvider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../util/navigation.dart';
import '../util/custom_button.dart';
import 'qrCode.dart';
import 'registerScreen.dart';

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
    getUserData();
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
        });
      } else {
        print('No user data found!');
      }
    } catch (e) {
      print(e);
    }
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
      showSnackBar(context, 'No user data found!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            title: const Text('My Booking'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Color.fromRGBO(237, 37, 78, 1),
                height: 1.0,
              ),
            )),
        body: Center(child: Builder(builder: (context) {
          if (bookingCodde != "") {
            return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
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
                      color: Colors.black,
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
                                Text('\t\t${bookingCodde}',
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                        const Text('|',
                            style: TextStyle(
                                fontSize: 60, fontWeight: FontWeight.w100)),
                        Container(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Waiting List'),
                                StreamBuilder<String>(
                                  stream: Stream.periodic(
                                          const Duration(seconds: 1))
                                      .asyncMap(
                                          (_) => ap.queueLeft(bookingCodde[0])),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // or any loading indicator
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                        '\t\t-',
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else if (snapshot.hasData) {
                                      String bookingCodes = snapshot.data!;
                                      print(bookingCodes);
                                      return Text(
                                        '\t\t$bookingCodes',
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
                      color: Colors.black,
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
                              Text(bookingDate.length > 10
                                  ? bookingDate.substring(0, 11)
                                  : '-')
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
                              Text(bookingDate.length > 10
                                  ? bookingDate.substring(10)
                                  : '-'),
                            ],
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Seat Quantities :'),
                        Text('${numberOfPeople}  People')
                      ],
                    ),
                    const Text('** One number can reserve only one table. **',
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRCode(
                                    data: bookingCodde,
                                  )),
                        );
                      },
                      text: 'แบบยืนยันตัวไนงี้',
                    ),
                    Center(
                        child: bookingCodde.isNotEmpty
                            ? CustomButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Are you sure you want to delete the booking?'),
                                        actions: [
                                          CustomButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the alert dialog
                                            },
                                            text: 'Cancel',
                                            Check: true,
                                          ),
                                          CustomButton(
                                            onPressed: () {
                                              deleteBooking();
                                              Navigator.of(context)
                                                  .pop(); // Close the alert dialog
                                            },
                                            text: 'Delete',
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                text: 'Cancel',
                              )
                            : const SizedBox()),
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
