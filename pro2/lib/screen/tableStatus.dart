import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

Color colorToggleActive = const Color.fromRGBO(237, 37, 78, 1);
Color colorToggleInactive = const Color.fromRGBO(97, 255, 0, 1);

class tableStatusScrren extends StatefulWidget {
  const tableStatusScrren({super.key});

  @override
  State<tableStatusScrren> createState() => _tableStatusScrrenState();
}

class _tableStatusScrrenState extends State<tableStatusScrren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Table Status'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: const Color.fromRGBO(237, 37, 78, 1),
              height: 1.0,
            ),
          )),
      body: const Center(
          child: Column(
        children: [
          SizedBox(height: 20),
          Status(tableNumber: '12P'),
          SizedBox(height: 20),
          Status(tableNumber: '34P'),
          SizedBox(height: 20),
          Status(tableNumber: '58P'),
        ],
      )),
    );
  }
}

class Status extends StatefulWidget {
  final String tableNumber;

  const Status({Key? key, required this.tableNumber}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  bool _isSwitched = false;

  int value = 0;

  @override
  void initState() {
    super.initState();
    getRealtimeTable(widget.tableNumber).then((value) {
      setState(() {
        _isSwitched = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String manyNumber = '';

    if (widget.tableNumber == '12P') {
      manyNumber = '1-2 P';
    } else if (widget.tableNumber == '34P') {
      manyNumber = '3-4 P';
    } else if (widget.tableNumber == '58P') {
      manyNumber = '5-8 P';
    }
    final item = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Move the color property here
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 82, 82, 82).withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 6,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !_isSwitched
                      ? Container(
                          height: 50,
                          child: Transform.translate(
                            offset: Offset(-25, 0),
                            child: Container(
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    side: const BorderSide(
                                        color: Colors.transparent, width: 1),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item[value] + " Available",
                                        style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    raelTimemanyPeopleDatabase(
                                        value, widget.tableNumber);
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoActionSheet(
                                            title:
                                                const Text('Table Available'),
                                            actions: <Widget>[
                                              CupertinoActionSheet(
                                                actions: [
                                                  Cupatino(item, manyNumber)
                                                ],
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          raelTimemanyPeopleDatabase(
                                                              value,
                                                              widget
                                                                  .tableNumber);
                                                        },
                                                        child:
                                                            const Text('OK')),
                                              )
                                            ],
                                          );
                                        });
                                  }),
                            ),
                          ),
                        )
                      : Container(
                          height: 50,
                          child: const Text("Unavailable",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                  Text(
                    manyNumber,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 114, 113, 113),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: CupertinoSwitch(
                value: _isSwitched,
                onChanged: (value) {
                  setState(() {
                    _isSwitched = value;
                    raeltimeDatabase(_isSwitched, widget.tableNumber);
                  });
                },
                activeColor: colorToggleActive,
                trackColor: colorToggleInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Cupatino(item, numberOfPeople) => SizedBox(
        height: 150, // specify a height for the ListView
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: value),
          looping: true,
          itemExtent: 40.0,
          onSelectedItemChanged: (int value) {
            setState(() => this.value = value);
          },
          children: <Widget>[
            for (var i in item)
              Center(child: Text(i, style: const TextStyle(fontSize: 20))),
          ],
        ),
      );
}

Future<bool> getRealtimeTable(String nameCol) async {
  final Completer<bool> completer = Completer<bool>();
  final databaseReference = FirebaseDatabase.instance.reference();

  databaseReference.child(nameCol).get().then((DataSnapshot snapshot) {
    var ref = snapshot.value as Map<dynamic, dynamic>;
    String data = ref['status'];
    if (data == 'false') {
      completer.complete(true);
    } else if (data == 'true') {
      completer.complete(false);
    }
  });

  return completer.future;
}

void raeltimeDatabase(bool _isSwitched, String nameCol) {
  DatabaseReference mRootRef = FirebaseDatabase.instance.reference();
  DatabaseReference mPRef = mRootRef.child(nameCol);
  if (_isSwitched == false) {
    mPRef.child("status").set('true');
  } else if (_isSwitched == true) {
    mPRef.child("status").set('false');
  }
}

void raelTimemanyPeopleDatabase(int value, String nameCol) {
  DatabaseReference mRootRef = FirebaseDatabase.instance.reference();
  DatabaseReference mPRef = mRootRef.child(nameCol);
  mPRef.child("people").set(value + 1);
}
