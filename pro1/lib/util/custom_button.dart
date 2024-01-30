import 'package:flutter/material.dart';

class CoutomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CoutomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ButtonStyle(
        // au to U
      ),
      child: Text(text, style: const TextStyle(fontSize: 20),),);
  }
}