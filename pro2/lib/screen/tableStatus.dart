import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import '../Custom/table.dart';
import 'navbar.dart';

Color colorToggleActive = const Color.fromRGBO(237, 37, 78, 1);
Color colorToggleInactive = const Color.fromRGBO(97, 255, 0, 1);

class tableStatusScrren extends StatefulWidget {
  const tableStatusScrren({super.key});

  @override
  State<tableStatusScrren> createState() => _tableStatusScrrenState();
}

class _tableStatusScrrenState extends State<tableStatusScrren> {
  int _selectedIndex = 1;
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
          SizedBox(height: 40),
          TableShow2P(color: Color.fromRGBO(202, 255, 170, 1)),
          SizedBox(height: 10),
          Text('Available',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 40),
          TableShow2P(color: Color.fromRGBO(255, 88, 88, 0.8)),
          SizedBox(height: 10),
          Text('Unavailable',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      )),
      bottomNavigationBar: navBarBottom(
        currentIndex: _selectedIndex,
      ),
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
                  raeltimeDatabase12P(_isSwitched12);
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
                  raeltimeDatabase34P(_isSwitched34);
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
                  raeltimeDatabase58P(_isSwitched58);
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

void raeltimeDatabase12P(bool _isSwitched) {
  DatabaseReference mRootRef = FirebaseDatabase.instance.reference();
  DatabaseReference m12PRef = mRootRef.child("12P");
  if (_isSwitched == false) {
    m12PRef.child("status").set('true');
  } else if (_isSwitched == true) {
    m12PRef.child("status").set('false');
  }
}

void raeltimeDatabase34P(bool _isSwitched) {
  DatabaseReference mRootRef = FirebaseDatabase.instance.reference();
  DatabaseReference m34PRef = mRootRef.child("34P");
  if (_isSwitched == false) {
    m34PRef.child("status").set('true');
  } else if (_isSwitched == true) {
    m34PRef.child("status").set('false');
  }
}

void raeltimeDatabase58P(bool _isSwitched) {
  DatabaseReference mRootRef = FirebaseDatabase.instance.reference();
  DatabaseReference m58PRef = mRootRef.child("58P");
  if (_isSwitched == false) {
    m58PRef.child("status").set('true');
  } else if (_isSwitched == true) {
    m58PRef.child("status").set('false');
  }
}
