import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/utils/format_phone_number.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';

class NameEntryScreen extends StatefulWidget {
  const NameEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  TextEditingController controller = TextEditingController();

  Future<int> updateUserInfo(String firstName, String phoneNumber) async {
    var response = await http
        .post(Uri.parse('http://127.0.0.1:8080/update_user_info'), body: {
      'phone_number': phoneNumber,
      'data': json.encode({'first_name': firstName})
    });

    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumberProvider = Provider.of<PhoneNumberProvider>(context);
    final exitCode = phoneNumberProvider.phoneNumber.exitCode;
    final userPhoneNumber = phoneNumberProvider.phoneNumber.phoneNumber;

    final phoneNumber = formatPhoneNumber(exitCode, userPhoneNumber, false);

    return Scaffold(
        // TODO: Remove appbar for user, keep for admin/dev
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("What's your first name?",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 25,
              ),
              TextField(
                autofocus: true,
                controller: controller,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Enter first name',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(
                height: 25,
              ),
              Text('This is how your name will appear on your profile.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              Text(
                "You can't change it later.",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 32.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: 75,
                        width: 75,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3.5, color: Colors.transparent),
                              gradient: const LinearGradient(
                                transform: GradientRotation(math.pi / 4),
                                colors: [
                                  Color(0xff7301E4),
                                  Color(0xff0E8BFF),
                                  Color(0xff09CBC8),
                                  Color(0xff33D15F),
                                ],
                              )),
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: TextButton(
                              child: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.black),
                              onPressed: () {
                                // Add some condition here that requires
                                // controller.text to not be an empty string
                                print(controller.text);
                                updateUserInfo(controller.text, phoneNumber);
                                Navigator.pushNamed(context, '/onboarding-dob');
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
