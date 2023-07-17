import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/utils/format_phone_number.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';

class DOBEntryScreen extends StatefulWidget {
  const DOBEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DOBEntryScreen> createState() => _DOBEntryScreenState();
}

class _DOBEntryScreenState extends State<DOBEntryScreen> {
  var m1Val = '';
  var m2Val = '';
  var d1Val = '';
  var d2Val = '';
  var y1Val = '';
  var y2Val = '';

  Future<int> updateUserInfo(String birthDate, String phoneNumber) async {
    var response = await http
        .post(Uri.parse('http://127.0.0.1:8080/update_user_info'), body: {
      'phone_number': phoneNumber,
      'data': json.encode({'birthdate': birthDate})
    });

    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyPhoneNumberProvider>(context);
    final exitCode = myProvider.myPhoneNumber.exitCode;
    final userPhoneNumber = myProvider.myPhoneNumber.phoneNumber;

    TextEditingController m1Controller = TextEditingController();
    TextEditingController m2Controller = TextEditingController();
    TextEditingController d1Controller = TextEditingController();
    TextEditingController d2Controller = TextEditingController();
    TextEditingController y1Controller = TextEditingController();
    TextEditingController y2Controller = TextEditingController();

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
              const Text("Your birthday?",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                        controller: m1Controller,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            m1Val = m1Controller.text;
                          });
                          if (value.isNotEmpty) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        autofocus: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'M',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          controller: m2Controller,
                          onChanged: (value) {
                            setState(() {
                              m2Val = m2Controller.text;
                            });
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          maxLength: 1,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'M',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  Text('/', style: TextStyle(color: Colors.grey[500])),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          controller: d1Controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              d1Val = d1Controller.text;
                            });
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          maxLength: 1,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'D',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          controller: d2Controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              d2Val = d2Controller.text;
                            });
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          maxLength: 1,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'D',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  Text('/', style: TextStyle(color: Colors.grey[500])),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          controller: y1Controller,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          onChanged: (value) {
                            setState(() {
                              y1Val = y1Controller.text;
                            });
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Y',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          controller: y2Controller,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              y2Val = y2Controller.text;
                            });
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          maxLength: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Y',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ))))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Text('Your profile shows your age, not your date of birth.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600])),
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
                                var birthDate =
                                    '$y1Val$y2Val$m1Val$m2Val$d1Val$d2Val';
                                var phoneNumber = formatPhoneNumber(
                                    exitCode, userPhoneNumber, false);
                                updateUserInfo(birthDate, phoneNumber);
                                Navigator.pushNamed(
                                    context, '/onboarding-gender');
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
