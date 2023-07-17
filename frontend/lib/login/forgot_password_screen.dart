import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:my_app/utils/format_phone_number.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';
import '../onboarding/phone_number_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  PhoneNumber number =
      PhoneNumber(isoCode: 'US', dialCode: '+1', phoneNumber: '');

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyPhoneNumberProvider>(context);
    final exitCode = myProvider.myPhoneNumber.exitCode;
    final userPhoneNumber = myProvider.myPhoneNumber.phoneNumber;
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
                    'No problem. Enter your phone number to receive a six digit number verification code.'),
              )
            ],
          ),
          const SizedBox(height: 25),
          InternationalPhoneNumberInput(
              selectorTextStyle:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              inputDecoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              onInputChanged: (PhoneNumber number) {
                print(controller.text);
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              },
              onInputValidated: (value) => {setState(() {})},
              autoFocus: true,
              selectorConfig: const SelectorConfig(
                  trailingSpace: false,
                  selectorType: PhoneInputSelectorType.DIALOG),
              ignoreBlank: false,
              textStyle:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              initialValue: number,
              textFieldController: controller,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
              spaceBetweenSelectorAndTextField: 0),
          const SizedBox(height: 35),
          PhoneVerification(
            exitCode: number.dialCode ?? '+1',
            phoneNumber: controller.text,
            verificationCode: '042195',
            forgotPassword: true,
          ),
        ],
      ),
    ));
  }
}
