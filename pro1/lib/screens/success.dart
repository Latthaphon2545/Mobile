import 'package:flutter/material.dart';

class SuccessfullyBooking extends StatefulWidget {
  final String name;
  final String tableNumber;
  final String time;
  const SuccessfullyBooking({
    Key? key,
    required this.name,
    required this.tableNumber,
    required this.time,
  }) : super(key: key);

  @override
  State<SuccessfullyBooking> createState() => _SuccessfullyBookingState();
}

class _SuccessfullyBookingState extends State<SuccessfullyBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Successfully Booking')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${widget.name}'),
            const SizedBox(height: 20),
            Text('Table Number: ${widget.tableNumber}'),
            const SizedBox(height: 20),
            Text('Time: ${widget.time}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}