import 'package:flutter/material.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:pro2/screen/scanQrCode.dart';

import 'history.dart';
import 'tableStatus.dart';
import 'waitListScreen.dart';

class navBarBottom extends StatefulWidget {
  final int currentIndex;
  const navBarBottom({super.key, required this.currentIndex});

  @override
  State<navBarBottom> createState() => _navBarBottomState();
}

class _navBarBottomState extends State<navBarBottom> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }
  @override
  Widget build(BuildContext context) {
    return CustomLineIndicatorBottomNavbar(
      selectedColor: const Color.fromRGBO(237, 37, 78, 1),
      unSelectedColor: Colors.black54,
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      unselectedIconSize: 15,
      selectedIconSize: 20,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => waitList()));
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => tableStatusScrren()));
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => historyScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => scanQr()));
          }
        });
      },
      enableLineIndicator: true,
      lineIndicatorWidth: 3,
      indicatorType: IndicatorType.Top,
      customBottomBarItems: [
        CustomBottomBarItems(
          label: 'Waitlist',
          icon: Icons.list,
        ),
        CustomBottomBarItems(
          label: 'Tabke Status',
          icon: Icons.table_restaurant,
        ),
        CustomBottomBarItems(
          label: 'History',
          icon: Icons.history,
        ),
      ],
    );
  }
}
