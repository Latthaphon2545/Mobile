import 'package:flutter/material.dart';
import 'package:pro2/Custom/custom_button.dart';

import '../BookList/bookingCodeA.dart';
import '../BookList/bookingCodeB.dart';
import '../BookList/bookingCodeC.dart';
import 'navbar.dart';

class waitList extends StatefulWidget {
  const waitList({Key? key}) : super(key: key);

  @override
  _waitListState createState() => _waitListState();
}

class _waitListState extends State<waitList> {
  bool _showCodeAScreen = true;
  bool _showCodeBScreen = false;
  bool _showCodeCScreen = false;
  bool actveA = false;
  bool actveB = true;
  bool actveC = true;

  // Timer? _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     setState(() {
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Waitlist',
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: const Color.fromRGBO(237, 37, 78, 1),
              height: 1.0,
            ),
          )),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          // padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    text: '1-2P',
                    width: 100,
                    onPressed: () {
                      setState(() {
                        _showCodeAScreen = true;
                        _showCodeBScreen = false;
                        _showCodeCScreen = false;
                        actveA = false;
                        actveB = true;
                        actveC = true;
                      });
                    },
                    Check: actveA,
                  ),
                  CustomButton(
                    text: '3-4P',
                    width: 100,
                    onPressed: () {
                      setState(() {
                        _showCodeAScreen = false;
                        _showCodeBScreen = true;
                        _showCodeCScreen = false;
                        actveA = true;
                        actveB = false;
                        actveC = true;
                      });
                    },
                    Check: actveB,
                  ),
                  CustomButton(
                    text: '5-8P',
                    width: 100,
                    onPressed: () {
                      setState(() {
                        _showCodeAScreen = false;
                        _showCodeBScreen = false;
                        _showCodeCScreen = true;
                        actveA = true;
                        actveB = true;
                        actveC = false;
                      });
                    },
                    Check: actveC,
                  ),
                ],
              ),
              const Divider(
                color: Color.fromRGBO(229, 230, 235, 1),
                thickness: 5,
                height: 40,
                indent: 0,
              ),
              if (_showCodeAScreen) Expanded(child: codeAScreen()),
              if (_showCodeBScreen) Expanded(child: codeBScreen()),
              if (_showCodeCScreen) Expanded(child: codeCScreen()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: navBarBottom(currentIndex: 0),
    );
  }
}
