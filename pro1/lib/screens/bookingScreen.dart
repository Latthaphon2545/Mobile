import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/profile_model.dart';
import '../provider/authProvider.dart';
import '../util/custom_button.dart';
import '../util/table.dart';
import '../util/utils.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _numberOfPeople = 1;
  // f.format(DateTime.now())
  Widget _buildTableShow() {
    const color = Color.fromRGBO(202, 255, 170, 1);
    switch (_numberOfPeople) {
      case 1:
        return const TableShow1P(color: color);
      case 2:
        return const TableShow2P(color: color);
      case 3:
        return const TableShow3P(color: color);
      case 4:
        return const TableShow4P(color: color);
      case 5:
        return const TableShow5P(color: color);
      case 6:
        return const TableShow6P(color: color);
      case 7:
        return const TableShow7P(color: color);
      case 8:
        return const TableShow8P(color: color);
      default:
        return const TableShow1P(color: color);
    }
  }

  final f = new DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(
          title: const Text('Booking'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Color.fromRGBO(237, 37, 78, 1),
              height: 1.0,
            ),
          )),
      body: Container(
        // color: Colors.white,
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200, // specify the height
              child: _buildTableShow(),
            ),
            TitleAndSub(
                title: 'Name',
                sub: Provider.of<AuthProvider>(context, listen: false)
                    .userModel
                    .name),
            TitleAndSub(
              title: 'Phone Numbser',
              sub: Provider.of<AuthProvider>(context, listen: false)
                  .userModel
                  .phoneNumber,
            ),
            TitleAndSub(title: 'Date', sub: f.format(DateTime.now())),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Number of People',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 110, 109, 109),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 15),
                        width: 60,
                        height: 65,
                        color: Colors.grey[300],
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '$_numberOfPeople',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(237, 37, 78, 1)),
                          ),
                        )),
                    Row(
                      children: [
                        Ink(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                )),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            color: Colors.red,
                            iconSize: 35,
                            onPressed: () {
                              setState(() {
                                if (_numberOfPeople > 1) {
                                  _numberOfPeople--;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Ink(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                )),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.red,
                            iconSize: 35,
                            onPressed: () {
                              setState(() {
                                if (_numberOfPeople < 8) {
                                  _numberOfPeople++;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Center(
              child: CustomButton(
                onPressed: () async {
                  if (await confrimBooking(context)) {
                    storeData();
                  }
                },
                text: 'Booking',
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> runbookingCode(int _selected) async {
    String bookingCode1st = '';
    if (_selected >= 1 && _selected <= 2) {
      bookingCode1st = 'A';
    } else if (_selected >= 3 && _selected <= 4) {
      bookingCode1st = 'B';
    } else if (_selected >= 5 && _selected <= 8) {
      bookingCode1st = 'C';
    }
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userData =
        await _firebaseFirestore
            .collection('booking')
            .where('bookingCode', isGreaterThanOrEqualTo: bookingCode1st)
            .where('bookingCode',
                isLessThan:
                    '${bookingCode1st}z') // assuming 'z' comes after possible bookingCode values
            .get();
    int numberOfBookings = userData.docs.length + 1;
    String bookingCode = bookingCode1st + numberOfBookings.toString();

    // Corrected the return statement
    return bookingCode;
  }

  Future<bool> confrimBooking(BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Confirm Booking'),
        content: Text('Are you sure you want to book?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          // cacle button
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void storeData() async {
    String bookCode = await runbookingCode(_numberOfPeople);
    // ignore: use_build_context_synchronously
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: ap.userModel.name,
      phoneNumber: ap.userModel.phoneNumber,
      createdAt: '',
      uid: ap.userModel.uid,
      bookingCode: bookCode,
      numberOfPeople: _numberOfPeople.toString(),
    );
    // ignore: unnecessary_null_comparison
    if (_numberOfPeople != null) {
      // ignore: use_build_context_synchronously
      ap.saveBookingDataTofirebasa(
          context: context,
          userModel: userModel,
          onSuccess: () {
            showSnackBar(context, 'Booking Success');
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/myBooking',
              (route) => false,
            );
          });
    } else {
      showSnackBar(context, 'Please select number of people');
    }
  }
}

class TitleAndSub extends StatelessWidget {
  final String title;
  final String sub;
  const TitleAndSub({Key? key, required this.title, required this.sub})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 110, 109, 109),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '\t\t${sub}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
