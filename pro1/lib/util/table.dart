import 'dart:ffi';
import 'package:flutter/material.dart';

class TableShow1P extends StatelessWidget {
  final Color color;
  const TableShow1P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildChair(color),
          const SizedBox(width: 20),
          _buildTable1(width: 120, height: 75, color: color),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class TableShow2P extends StatelessWidget {
  final Color color;
  const TableShow2P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildChair(color),
          const SizedBox(width: 20),
          _buildTable2(width: 150, height: 75, color: color),
          const SizedBox(width: 11),
          _buildChair(color),
        ],
      ),
    );
  }
}

// This method builds a container with the given width and height
Widget _buildContainer(
    {required double width, required double height, required Color color}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      // color: Color.fromRGBO(202, 255, 170, 1),
      color: color,
      borderRadius: BorderRadius.circular(40),
    ),
  );
}

// This method builds the table
Widget _buildTable1(
    {required double width, required double height, required Color color}) {
  Color colorDish = Colors.white;
  if (color == const Color.fromRGBO(202, 255, 170, 1)) {
    colorDish = const Color.fromRGBO(95, 255, 0, 1);
  } else {
    colorDish = const Color.fromRGBO(255, 88, 88, 1);
  }
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      // color: Color.fromRGBO(202, 255, 170, 1),
      color: color,
    ),
    child: Row(children: [
      const SizedBox(width: 7.5),
      _buildDish(color: colorDish),
    ]),
  );
}

// This method builds the table
Widget _buildTable2(
    {required double width, required double height, required Color color}) {
  Color colorDish = Colors.white;
  if (color == const Color.fromRGBO(202, 255, 170, 1)) {
    colorDish = const Color.fromRGBO(95, 255, 0, 1);
  } else {
    colorDish = const Color.fromRGBO(255, 88, 88, 1);
  }
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      // color: Color.fromRGBO(202, 255, 170, 1),
      color: color,
    ),
    child: Row(children: [
      const SizedBox(width: 7.5),
      _buildDish(color: colorDish),
      const SizedBox(width: 60),
      _buildDish(color: colorDish),
    ]),
  );
}

// This method builds the table
Widget _buildTable1Land(
    {required double width,
    required double height,
    required Color color,
    double many = 0}) {
  Color colorDish = Colors.white;
  if (color == const Color.fromRGBO(202, 255, 170, 1)) {
    colorDish = const Color.fromRGBO(95, 255, 0, 1);
  } else {
    colorDish = const Color.fromRGBO(255, 88, 88, 1);
  }

  if (many == 1) {
    colorDish = Color.fromRGBO(202, 255, 170, 1);
  }

  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
    ),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildDish(color: colorDish),
    ]),
  );
}

// This method builds a Dish
Widget _buildDish({required Color color}) {
  return Container(
    width: 37.5,
    height: 37.5,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(50),
    ),
  );
}

// This method builds a chair
Widget _buildChair(Color color) {
  return Container(
    width: 50,
    height: 35,
    decoration: BoxDecoration(
      // color: Color.fromRGBO(202, 255, 170, 1),
      borderRadius: BorderRadius.circular(40),
    ),
    child: Icon(
      Icons.person,
      color: color,
      size: 50,
    ),
  );
}

Widget _buildChairLand(color, {double width = 50, double height = 35}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      // color: Color.fromRGBO(202, 255, 170, 1),
      borderRadius: BorderRadius.circular(40),
    ),
    child: Icon(
      Icons.person,
      color: color,
      size: 50,
    ),
  );
}

class MakeTable1PLanscape extends StatelessWidget {
  final Color color;
  const MakeTable1PLanscape({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 5),
              _buildChairLand(color),
            ],
          ),
          const SizedBox(height: 10),
          _buildTable1Land(width: 55, height: 50, color: color),
          _buildTable1Land(width: 55, height: 50, color: color, many: 1),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class MakeTable2PLanscape extends StatelessWidget {
  final Color color;
  const MakeTable2PLanscape({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Column(
            children: [
              _buildChairLand(color),
            ],
          ),
          const SizedBox(height: 15),
          _buildTable1Land(width: 55, height: 50, color: color),
          _buildTable1Land(width: 55, height: 50, color: color),
          Column(
            children: [
              _buildChairLand(color),
            ],
          ),
        ],
      ),
    );
  }
}

class TableShow3P extends StatelessWidget {
  final Color color;
  const TableShow3P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable1PLanscape(
            color: color,
          )
        ],
      ),
    );
  }
}

class TableShow4P extends StatelessWidget {
  final Color color;
  const TableShow4P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          )
        ],
      ),
    );
  }
}

class TableShow5P extends StatelessWidget {
  final Color color;
  const TableShow5P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable1PLanscape(
            color: color,
          )
        ],
      ),
    );
  }
}

class TableShow6P extends StatelessWidget {
  final Color color;
  const TableShow6P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          )
        ],
      ),
    );
  }
}

class TableShow7P extends StatelessWidget {
  final Color color;
  const TableShow7P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable1PLanscape(
            color: color,
          )
        ],
      ),
    );
  }
}

class TableShow8P extends StatelessWidget {
  final Color color;
  const TableShow8P({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          ),
          MakeTable2PLanscape(
            color: color,
          )
        ],
      ),
    );
  }
}
