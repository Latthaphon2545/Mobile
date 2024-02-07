import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/custom_button.dart';
import 'homeScreen.dart';
import '../models/profile_model.dart';
import '../provider/authProvider.dart';

class UserInfomationScreen extends StatefulWidget {
  // final String uidCur;
  // UserInfomationScreen({Key? key, required this.uidCur}) : super(key: key);
  UserInfomationScreen({Key? key}) : super(key: key);

  @override
  State<UserInfomationScreen> createState() => _UserInfomationScreenState();
}

class _UserInfomationScreenState extends State<UserInfomationScreen> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Infomation'),
      ),
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.purple,
              ))
            : Center(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: nameController,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      onChanged: (value) {
                        setState(() {
                          nameController.text = value;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                        text: 'Next',
                        onPressed: () {
                          storeData();
                        },
                      ),
                    ),
                  ],
                ),
              )),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String name = nameController.text.trim();
    UserModel userModelCur =
        UserModel(name: name, phoneNumber: '', createdAt: '', uid: '');
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
        ),
      );
      return;
    } else {
      ap.saveUserDataTofirebasa(
        context: context,
        userModel: userModelCur,
        onSuccess: () async {
          ap.saveUserDataToSP().then(
                (value) => ap.setSingIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                        (route) => false,
                      ),
                    ),
              );
        },
      );
    }
  }
}
