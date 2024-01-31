import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:pro1/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../util/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController phoneController = TextEditingController();
  final nameController = TextEditingController();

  Country SelectCountry = Country(
    phoneCode: '66',
    countryCode: 'TH',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Thailand',
    example: 'Thailand',
    displayName: 'Thailand',
    displayNameNoCountryCode: 'TH',
    e164Key: '',
  );

  Color colorTheam = Colors.black;

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                cursorColor: colorTheam,
                controller: phoneController,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  setState(() {
                    phoneController.text = value;
                    if (value.length >= 9) {
                      colorTheam = Colors.green;
                    } else if (value.isEmpty) {
                      colorTheam = Colors.black;
                    } else {
                      colorTheam = Colors.red;
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.grey),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                              bottomSheetHeight: 500,
                            ),
                            onSelect: (value) {
                              setState(() {
                                SelectCountry = value;
                              });
                            });
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(SelectCountry.flagEmoji,
                                style: const TextStyle(fontSize: 20)),
                            Text('+${SelectCountry.phoneCode}',
                                style: const TextStyle(fontSize: 15)),
                          ]),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorTheam,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CoutomButton(
                  text: 'Next',
                  onPressed: () => sendPhoneNumber(),
                ),
              ),        
            ],
          ),
        )),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    print("+${SelectCountry.phoneCode}$phoneNumber");
    ap.signInWithPhone(context, "+${SelectCountry.phoneCode}$phoneNumber");
  }
}
