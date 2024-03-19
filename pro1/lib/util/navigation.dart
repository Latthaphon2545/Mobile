import 'package:flutter/material.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';

import '../screens/homeScreen.dart';
import '../screens/myBooking.dart';

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
          if (index == 0 && selectedIndex != widget.currentIndex) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (index == 1 && selectedIndex != widget.currentIndex) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MyBooking()));
          }
        });
      },
      enableLineIndicator: true,
      lineIndicatorWidth: 3,
      customBottomBarItems: [
        CustomBottomBarItems(
          label: 'Home',
          icon: Icons.home,
        ),
        CustomBottomBarItems(
          label: 'My Booking',
          icon: Icons.bookmark,
        ),
      ],
    );
  }
}
