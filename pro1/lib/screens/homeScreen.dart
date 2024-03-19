// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    Future.delayed(Duration.zero, () {
      getUserData();
    });
  }

  void getUserData() async {
    if (!mounted) return;

    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('users')
            .where('uid', isEqualTo: ap.userModel.uid)
            .get();
    if (!mounted) return;
    try {
      setState(() {
        name = userData.docs[0]['name'];
        phone = userData.docs[0]['phoneNumber'];
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'No user data found!');
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/RegisterScreen',
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            title: const Text('Home'),
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: const Color.fromRGBO(237, 37, 78, 1),
                height: 1.0,
              ),
            )),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10), // Add radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      FutureBuilder<String>(
                        future: ap.getBookingCode(ap.userModel.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
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
                  // padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10), // Add radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: StreamBuilder<Map<String, String>>(
                    stream: ap.realtimeBookingData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        Map<String, String> bookingCodes = snapshot.data!;
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Table Status",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Color.fromARGB(59, 0, 0, 0),
                  height: 0,
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamScreen(
                          onTableChange: () => ap.getRealtimeTable('12P'),
                          peopleCount: '1-2',
                          numberOfpeople: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamScreen(
                          onTableChange: () => ap.getRealtimeTable('34P'),
                          peopleCount: '3-4',
                          numberOfpeople: 3,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamScreen(
                          onTableChange: () => ap.getRealtimeTable('58P'),
                          peopleCount: '5-8',
                          numberOfpeople: 5,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.19,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          width: 100,
          child: FloatingActionButton(
            onPressed: () {
              checkBookinginData(context);
            },
            backgroundColor: const Color.fromRGBO(237, 37, 78, 1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.book,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 7,
                ),
                Text('Book',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
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

class StreamScreen extends StatelessWidget {
  final Function onTableChange;
  final String peopleCount;
  final int numberOfpeople;
  const StreamScreen(
      {Key? key,
      required this.onTableChange,
      required this.peopleCount,
      required this.numberOfpeople})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TableStatus>(
        stream: onTableChange(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            bool isTableAvailable = snapshot.data!.status;
            int peopleCountDatabase = snapshot.data!.peopleCount;
            Color color;
            String boolText;
            if (isTableAvailable) {
              color = const Color.fromRGBO(202, 255, 170, 1);
              boolText = "A";
            } else {
              color = const Color.fromRGBO(255, 164, 164, 1);
              boolText = "Ua";
            }

            String imgPath = 'assets/images/${numberOfpeople}${boolText}.png';

            return Container(
              width: MediaQuery.of(context).size.width * 0.39,
              height: MediaQuery.of(context).size.height * 0.19,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  // Add border here
                  color: const Color.fromARGB(71, 0, 0, 0), // Border color
                  width: 1, // Border width
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            '\t\t${isTableAvailable ? '${peopleCountDatabase}/10 ' : '-'}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isTableAvailable)
                            Icon(Icons.table_restaurant_outlined),
                        ],
                      ),
                      Text("\t\t\t\t\t${peopleCount} People",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          )),
                      Center(
                        child: Image.asset(
                          imgPath,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Text('No data available.');
        });
  }
}
