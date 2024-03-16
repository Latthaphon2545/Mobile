import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Widget'),
      ),
      body: const Center(
        child: Text(
            'Hello, World! Go to pro2/lib/Custom/table.dart to see the changes.'),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyWidget(),
  ));
}
