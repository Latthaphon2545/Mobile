import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Custom/custom_card.dart';

class historyScreen extends StatelessWidget {
  const historyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: const Color.fromRGBO(237, 37, 78, 1),
              height: 1.0,
            ),
          )
      ),
      body: const historyList(),
    );
  }
}

class historyList extends StatefulWidget {
  const historyList({Key? key}) : super(key: key);

  @override
  State<historyList> createState() => _historyListState();
}

class _historyListState extends State<historyList> {
  @override
  Widget build(BuildContext context) =>
      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getHistoryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
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
                      subtitle: cardHistory(
                        userData: userData as Map<String, dynamic>,
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      );

  Future<QuerySnapshot<Map<String, dynamic>>> getHistoryData() async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    return await _firebaseFirestore.collection('history').get();
  }
}
