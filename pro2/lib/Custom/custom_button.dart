import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool Check;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.Check = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Color.fromRGBO(237, 37, 78, 1);
    if (Check) {
      color = Colors.grey;
    }
    return Container(
      width: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
          shadowColor: Colors.black,
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
