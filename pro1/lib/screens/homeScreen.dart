// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pro1/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:pro1/provider/authProvider.dart';

import '../util/navigation.dart';
import 'bookingScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String name = '';
  String phone = '';

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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/RegisterScreen',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                onPressed: () async {
                  checkBookinginData(context);
                },
                icon: const Text(
                  'Book',
                  style: TextStyle(
                      color: Color.fromRGBO(237, 37, 78, 1),
                      // fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: const Color.fromRGBO(237, 37, 78, 1),
                height: 1.0,
              ),
            )),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10), // Add radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    FutureBuilder<String>(
                      future: ap.getBookingCode(ap.userModel.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // or any loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.data == '') {
                            return const Text('Your Queue: Not Booked Yet!');
                          } else {
                            return Text('Your Queue: ${snapshot.data}');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                // padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10), // Add radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: StreamBuilder<Map<String, String>>(
                  stream: Stream.periodic(const Duration(seconds: 1))
                      .asyncMap((_) => ap.realtimeBookingData()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // or any loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      Map<String, String> bookingCodes = snapshot.data!;
                      print(bookingCodes);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          showQ(
                            manyPeople: '1-2 People',
                            bookingCode: bookingCodes['A'] ?? '',
                          ),
                          Text('|',
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey[500])),
                          showQ(
                            manyPeople: '3-4 People',
                            bookingCode: bookingCodes['B'] ?? '',
                          ),
                          Text('|',
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey[500])),
                          showQ(
                            manyPeople: '5-8 People',
                            bookingCode: bookingCodes['C'] ?? '',
                          ),
                        ],
                      );
                    } else {
                      return const Text('No data available.');
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamScreen(
                    onTableChange: () => getRealtimeTable('12P'),
                    peopleCount: '1-2',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamScreen(
                    onTableChange: () => getRealtimeTable('34P'),
                    peopleCount: '3-4',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamScreen(
                    onTableChange: () => getRealtimeTable('58P'),
                    peopleCount: '5-8',
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: navBarBottom(
          currentIndex: _currentIndex,
        ));
  }

  void checkBookinginData(BuildContext context) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('booking')
            .where('uid', isEqualTo: ap.userModel.uid)
            .get();

    // RangeError (index): Invalid value: Valid value range is empty: 0 of user data found!
    if (userData.docs.isEmpty) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BookingScreen()));
    }

    try {
      if (userData.docs[0]['bookingCode'] == "") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BookingScreen()));
      } else {
        showSnackBar(context, 'User has booked already');
      }
    } catch (e) {
      print(e);
    }
  }
}

class showQ extends StatelessWidget {
  final String manyPeople, bookingCode;
  const showQ({super.key, required this.manyPeople, required this.bookingCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 100,
      child: Column(
        children: [
          Text('$manyPeople',
              style: const TextStyle(
                fontSize: 13,
              )),
          const SizedBox(height: 10),
          Text(
            '$bookingCode',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(237, 37, 78, 1)),
          )
        ],
      ),
    );
  }
}

Future<bool> getRealtimeTable(String childNode) async {
  final Completer<bool> completer = Completer<bool>();
  final databaseReference = FirebaseDatabase.instance.reference();

  databaseReference.child(childNode).get().then((DataSnapshot snapshot) {
    var data = snapshot.value;
    data = data.toString().split(':')[1].split('}')[0].trim();
    if (data == 'true') {
      completer.complete(true);
    } else if (data == 'false') {
      completer.complete(false);
    }
  });

  return completer.future;
}

class StreamScreen extends StatefulWidget {
  final Function onTableChange;
  final String peopleCount;
  const StreamScreen(
      {Key? key, required this.onTableChange, required this.peopleCount})
      : super(key: key);

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: Stream.periodic(const Duration(seconds: 1))
            .asyncMap((_) => widget.onTableChange()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // or any loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            bool isTableAvailable = snapshot.data!;
            Color color;
            Color colorText;
            if (isTableAvailable) {
              color = Color.fromRGBO(202, 255, 170, 1);
              colorText = Colors.green;
            } else {
              color = Color.fromRGBO(255, 164, 164, 1);
              colorText = Colors.red;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Text("${widget.peopleCount} People"),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.person,
                        color: color,
                        size: 50,
                      )
                    ],
                  ),
                ),
                Text(isTableAvailable ? 'Available' : 'Unavailable',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorText))
              ],
            );
          }
          return const Text('No data available.');
        });
  }
}
