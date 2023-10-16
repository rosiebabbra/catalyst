import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Ethnicity {
  int ethnicityId;
  String ethnicityDesc;

  Ethnicity({required this.ethnicityId, required this.ethnicityDesc});
}

class EthnicityIDEntryScreen extends StatefulWidget {
  const EthnicityIDEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EthnicityIDEntryScreen> createState() => _EthnicityIDEntryScreenState();
}

class _EthnicityIDEntryScreenState extends State<EthnicityIDEntryScreen> {
  bool americanIndianSelected = false;
  bool asianSelected = false;
  bool blackSelected = false;
  bool middleEasternSelected = false;
  bool nativeHawaiianSelected = false;
  bool nonWhiteHispanicSelected = false;
  bool whiteHispanicSelected = false;
  bool whiteNonHispanicSelected = false;
  bool preferNotDiscloseSelected = false;

  List selectedEthnicities = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendData() async {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8080/ethnicity'),
        body: {'user_id': '1'});
    if (response.statusCode == 200) {
      // Handle successful response
      final data = response.body;
      List<dynamic> jsonList = jsonDecode(data);

      setState(() {
        // selectedEthnicities = jsonList;
      });
    } else {
      throw Exception('Failed to load data from backend');
    }
  }

  void updateSelectedEthnicities(ethnicity) {
    selectedEthnicities.add(ethnicity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text("Which category best describes you?",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select all that apply.',
                  style: TextStyle(color: Colors.grey[600]!, fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Column(children: [
                Row(children: [
                  Checkbox(
                    value: americanIndianSelected,
                    onChanged: (value) {
                      setState(() {
                        americanIndianSelected = value!;
                      });
                    },
                  ),
                  const Text('American Indian or Alaska Native',
                      style: TextStyle(fontSize: 16))
                ]),
                Row(
                  children: [
                    Checkbox(
                      value: asianSelected,
                      onChanged: (value) {
                        setState(() {
                          asianSelected = value!;
                        });
                      },
                    ),
                    const Text('Asian', style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: blackSelected,
                      onChanged: (value) {
                        setState(() {
                          blackSelected = value!;
                        });
                      },
                    ),
                    const Text('Black or African American',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: middleEasternSelected,
                      onChanged: (value) {
                        setState(() {
                          middleEasternSelected = value!;
                        });
                      },
                    ),
                    const Text('Middle Eastern or North African',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: nativeHawaiianSelected,
                      onChanged: (value) {
                        setState(() {
                          nativeHawaiianSelected = value!;
                        });
                      },
                    ),
                    const Text('Native Hawaiian or other Pacific Islander',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: nonWhiteHispanicSelected,
                      onChanged: (value) {
                        setState(() {
                          nonWhiteHispanicSelected = value!;
                        });
                      },
                    ),
                    const Text('Non-white Hispanic, Latino or Spanish',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: whiteHispanicSelected,
                      onChanged: (value) {
                        setState(() {
                          whiteHispanicSelected = value!;
                        });
                      },
                    ),
                    const Text('White (Hispanic, Latino, or Spanish)',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: whiteNonHispanicSelected,
                      onChanged: (value) {
                        setState(() {
                          whiteNonHispanicSelected = value!;
                        });
                      },
                    ),
                    const Text('White (Not Hispanic, Latino or Spanish)',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: preferNotDiscloseSelected,
                      onChanged: (value) {
                        setState(() {
                          preferNotDiscloseSelected = value!;
                        });
                      },
                    ),
                    const Text('Prefer not to disclose',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 50.0, 0),
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
                              sendData();
                              Navigator.pushNamed(
                                  context, '/location-disclaimer');
                            },
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ));
  }
}
