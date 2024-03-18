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
          statusP12(),
          statusP34(),
          statusP58(),
        ],
      )),
    );
  }
}

class statusP12 extends StatefulWidget {
  const statusP12({super.key});

  @override
  State<statusP12> createState() => _statusP12State();
}

class _statusP12State extends State<statusP12> {
  bool _isSwitched12 = false;

  @override
  void initState() {
    super.initState();
    getRealtimeTable('12P').then((value) {
      setState(() {
        _isSwitched12 = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('1P-2P Table'),
            trailing: CupertinoSwitch(
              value: _isSwitched12,
              onChanged: (value) {
                setState(() {
                  _isSwitched12 = value;
                  print(_isSwitched12);
                  raeltimeDatabase(_isSwitched12, '12P');
                });
              },
              activeColor: colorToggleActive,
              trackColor: colorToggleInactive,
            ),
          ),
        ],
      ),
    );
  }
}

class statusP34 extends StatefulWidget {
  const statusP34({super.key});

  @override
  State<statusP34> createState() => _statusP34State();
}

class _statusP34State extends State<statusP34> {
  bool _isSwitched34 = false;

  @override
  void initState() {
    super.initState();
    getRealtimeTable('34P').then((value) {
      setState(() {
        _isSwitched34 = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('3P-4P Table'),
            trailing: CupertinoSwitch(
              value: _isSwitched34,
              onChanged: (value) {
                setState(() {
                  _isSwitched34 = value;
                  print(_isSwitched34);
                  raeltimeDatabase(_isSwitched34, '34P');
                });
              },
              activeColor: colorToggleActive,
              trackColor: colorToggleInactive,
            ),
          ),
        ],
      ),
    );
  }
}

class statusP58 extends StatefulWidget {
  const statusP58({super.key});

  @override
  State<statusP58> createState() => _statusP58State();
}

class _statusP58State extends State<statusP58> {
  bool _isSwitched58 = false;

  @override
  void initState() {
    super.initState();
    getRealtimeTable('58P').then((value) {
      setState(() {
        _isSwitched58 = value;
      });
    });

    print(_isSwitched58);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('5P-8P Table'),
            trailing: CupertinoSwitch(
              value: _isSwitched58,
              onChanged: (value) {
                setState(() {
                  _isSwitched58 = value;
                  print(_isSwitched58);
                  raeltimeDatabase(_isSwitched58, '58P');
                });
              },
              activeColor: colorToggleActive,
              trackColor: colorToggleInactive,
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> getRealtimeTable(String nameCol) async {
  final Completer<bool> completer = Completer<bool>();
  final databaseReference = FirebaseDatabase.instance.reference();

  databaseReference.child(nameCol).get().then((DataSnapshot snapshot) {
    var data = snapshot.value;
    data = data.toString().split(':')[1].split('}')[0].trim();
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
