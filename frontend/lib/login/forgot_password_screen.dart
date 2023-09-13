import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:my_app/utils/format_phone_number.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_data.dart';
import '../onboarding/phone_number_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  PhoneNumber number =
      PhoneNumber(isoCode: 'US', dialCode: '+1', phoneNumber: '');

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<PhoneNumberProvider>(context);
    final exitCode = myProvider.phoneNumber.exitCode;
    final userPhoneNumber = myProvider.phoneNumber.phoneNumber;
    PhoneNumber number =
        PhoneNumber(isoCode: 'US', dialCode: '+1', phoneNumber: '');
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(45.0, 0, 65.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, // Set border color
                        width: 3.0),
                    borderRadius: BorderRadius.circular(36)),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25.0,
                  child: Icon(
                    Icons.phone,
                    color: Colors.black,
                    size: 36.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Flexible(
                child: Text("Forgot your password?",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Flexible(
                child: Text(
                    'No problem. Enter your email to receive a six digit number verification code.'),
              )
            ],
          ),
          const SizedBox(height: 25),
          TextField(
            controller: controller,
          ),
          const SizedBox(height: 35),
          ElevatedButton(
              onPressed: () {
                // TODO: Commenting out since we know this works - set a flag to
                // not call `_resetPassword` in debug/dev mode, but to call in prod
                // _resetPassword(controller.text);
                Navigator.pushNamed(context, '/password-reset-landing-page');
              },
              child: Text('Reset password'))
        ],
      ),
    ));
  }
}
