import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/utils/format_phone_number.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';
import 'phone_number_screen.dart';

void submitVerificationCode(String verificationCode) async {
  // Create a PhoneAuthCredential with the verification code and ID
  var verificationId;
  print(verificationCode);
  final PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: verificationCode,
  );

  // Sign in with the credential
  final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  final User? user = userCredential.user;

  // Do something with the signed-in user
  print('User ${user!.uid} signed in');
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyPhoneNumberProvider>(context);
    final exitCode = myProvider.myPhoneNumber.exitCode;
    final userPhoneNumber = myProvider.myPhoneNumber.phoneNumber;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(45.0, 0.0, 65.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 25),
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
                      backgroundColor: Colors.white,
                      radius: 25.0,
                      child: Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 36.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Flexible(
                    child: Text(
                      'Enter verification code',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                  'The code sent to you will verify your account through your mobile service provider.'),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: controller,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Row(
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
                              submitVerificationCode('042195');
                            },
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 35),
              SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () {
                    verifyUserPhoneNumber(
                        formatPhoneNumber(exitCode, userPhoneNumber, true),
                        '042195');
                  },
                  child: const Text('Resend code',
                      style: TextStyle(color: Color(0xff7301E4), fontSize: 16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                child: SizedBox(
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Re-enter phone number',
                        style:
                            TextStyle(color: Color(0xff7301E4), fontSize: 16)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
