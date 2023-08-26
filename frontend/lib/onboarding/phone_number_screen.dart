import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
import '../utils/format_phone_number.dart';
import '../models/user_data.dart';
import '../utils/text_fade.dart';
import '../widgets/button.dart';
import 'package:http/http.dart' as http;

class PhoneVerification extends StatefulWidget {
  final String exitCode;
  final String phoneNumber;
  final String verificationCode;
  final bool forgotPassword;

  const PhoneVerification({
    super.key,
    required this.exitCode,
    required this.phoneNumber,
    required this.verificationCode,
    required this.forgotPassword,
  });

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  bool _isElevated = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<int> checkUserPresence(phoneNumber) async {
    var response = await http.post(
        Uri.parse('http://127.0.0.1:8080/user_presence'),
        body: {'exit_code': widget.exitCode, 'phone_number': phoneNumber});

    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text('Next'),
          onPressed: () async {
            print('pressed');
            PhoneNumberProvider provider =
                Provider.of<PhoneNumberProvider>(context, listen: false);
            provider.updateData(UserPhoneNumber(
                exitCode: widget.exitCode, phoneNumber: widget.phoneNumber));

            int statusCode = await checkUserPresence(widget.phoneNumber);

            if (statusCode == 200) {
              // This condition occurs when a user already exists but is attemping to register
              if (widget.forgotPassword == false) {
                // Show a SnackBar with a message and redirect to login page
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 5),
                  content: Column(
                    children: const [
                      Text(
                        "Hey, we've seen you here before!",
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                          'Looks like you\'ve already registered, so you will now be redirected to our login page'),
                    ],
                  ),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {},
                  ),
                ));
                Future.delayed(const Duration(seconds: 6), () {
                  Navigator.pushNamed(context, '/matches');
                });
              }
              // CHECKED! This condition occurs when a user already exists but has forgetten their password
              else {
                _isElevated = !_isElevated;
                // Comment out while developing, uncomment before deploying
                verifyUserPhoneNumber(
                    formatPhoneNumber(
                        widget.exitCode, widget.phoneNumber, true),
                    widget.verificationCode);

                // Instead of 'resetting the password' since we're not actually using
                // email password login, just go to the matches page after verifying...

                // Future.delayed(const Duration(seconds: 6), () {
                //   Navigator.pushNamed(context, '/password-reset');
                // });

                Future.delayed(const Duration(seconds: 6), () {
                  Navigator.pushNamed(context, '/verification-screen');
                });
              }
            } else {
              // CHECKED! This condition occurs when a user does not exist and is attempting to reset their password
              if (widget.forgotPassword == true) {
                // Show a SnackBar with a message and redirect to login page
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 5),
                  content: Column(
                    children: const [
                      Text(
                        "Looks like you're new here!",
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                          "Since you haven't registered yet, you'll now be redirected to our registration page"),
                    ],
                  ),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {},
                  ),
                ));
                Future.delayed(const Duration(seconds: 6), () {
                  Navigator.pushNamed(context, '/onboarding');
                });
              } else {
                createUser(widget.exitCode, widget.phoneNumber, 'testing',
                    'testing', '2');
                Navigator.pushNamed(context, '/onboarding-name');
              }
            }
          },
        ),
      ],
    );
  }
}

Future<void> verifyUserPhoneNumber(
    String phoneNumber, String verificationCode) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber, // grab from user input
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      print('Verification completed');
    },
    verificationFailed: (FirebaseAuthException e) {
      print(e.message);
      print('Verification failed');
    },
    codeSent: (String verificationId, int? resendToken) async {
      // Update the UI - wait for the user to enter the SMS code

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: verificationCode);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      print('Code sent');
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      print('Timeout');
    },
  );
}

// For some reason an error surfaces when an int is passed in for
// the `roleId`, so it is just being converted to an int on the server side.
Future<void> createUser(String exitCode, String phoneNumber, String firstName,
    String lastName, String roleId) async {
  final response = await http
      .post(Uri.parse('http://127.0.0.1:8080/create_user'), body: {
    'exit_code': exitCode,
    'phone_number': phoneNumber,
    'role_id': roleId
  });
  if (response.statusCode == 204) {
    // Handle successful response
    print('complete');
  } else {
    throw Exception('Failed to create user');
  }
}

// Overarching widget
class PhoneNumberEntryScreen extends StatefulWidget {
  const PhoneNumberEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PhoneNumberEntryScreen> createState() => _PhoneNumberEntryScreenState();
}

class _PhoneNumberEntryScreenState extends State<PhoneNumberEntryScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  PhoneNumber number =
      PhoneNumber(isoCode: 'US', dialCode: '+1', phoneNumber: '');
  String dialCode = '+1';

  bool devMode = (Platform.environment['DEV_MODE'] == null) ? false : true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: devMode
              ? AppBar(
                  elevation: 0,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(45.0, 0, 65.0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Icon(Icons.phone_iphone, size: 45)),
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: FadeInText(
                        animationDuration: const Duration(milliseconds: 400),
                        offset: 2,
                        child: const Text("What's your phone number?",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Flexible(
                      child: FadeInText(
                        animationDuration: const Duration(milliseconds: 1200),
                        offset: 2,
                        child: const Text(
                            'You will be sent a six digit code to verify your identity.'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 65),
                InternationalPhoneNumberInput(
                    selectorTextStyle: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    inputDecoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onInputChanged: (PhoneNumber number) {
                      controller.selection = TextSelection.collapsed(
                          offset: controller.text.length);
                      setState(() {
                        number = number;
                        dialCode = number.dialCode ?? '+1';
                      });
                    },
                    onInputValidated: (value) => {},
                    autoFocus: true,
                    selectorConfig: const SelectorConfig(
                        trailingSpace: false,
                        selectorType: PhoneInputSelectorType.DIALOG),
                    ignoreBlank: false,
                    textStyle: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: true,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    onSaved: (PhoneNumber number) {},
                    spaceBetweenSelectorAndTextField: 0),
                const SizedBox(
                  height: 175,
                ),
                PhoneVerification(
                  exitCode: dialCode,
                  phoneNumber: controller.text,
                  verificationCode: '042195',
                  forgotPassword: false,
                )
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
