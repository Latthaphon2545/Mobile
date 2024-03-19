
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro2/BookList/waitList.dart';

import '../Custom/custom_card.dart';

class codeAScreen extends StatefulWidget {
  const codeAScreen({Key? key}) : super(key: key);

  @override
  State<codeAScreen> createState() => _codeAScreenState();
}

class _codeAScreenState extends State<codeAScreen> {
  @override
  Widget build(BuildContext context) =>
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getUserBookingData("A"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No user data found.'));
          } else {
            return Center(
              child: Container(
                // for example, half the screen height
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var userData = snapshot.data!.docs[index].data();
                    return ListTile(
                      subtitle: cardWaitlist(
                        userData: userData as Map<String, dynamic>,
                        Screen: const codeAScreen(),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      );
}
