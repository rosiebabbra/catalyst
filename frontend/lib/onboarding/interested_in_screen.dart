// Not using this screen atm

import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ExperienceType { dating, networking, friends }

bool _isDatingBorderColorEnabled = false;
bool _isFriendsBorderColorEnabled = false;
bool _isNetworkingBorderColorEnabled = false;

Color _selectedBorderColor = const Color(0xff7301E4);
Color _defaultBorderColor = Colors.grey[400]!;

class InterestedInScreen extends StatefulWidget {
  const InterestedInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InterestedInScreen> createState() => _InterestedInScreenState();
}

class _InterestedInScreenState extends State<InterestedInScreen> {
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
              padding: EdgeInsets.fromLTRB(25, 5, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text("Right now I'm interested in...",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Select all that apply.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                        color: _isDatingBorderColorEnabled
                            ? const Color(0xff7301E4)
                            : _defaultBorderColor,
                        width: 2.0,
                      )),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide()))),
                  onPressed: () {
                    setState(() {
                      _isDatingBorderColorEnabled =
                          !_isDatingBorderColorEnabled;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: const Color(0xff7301E4),
                        value: _isDatingBorderColorEnabled,
                        onChanged: (bool? value) {},
                      ),
                      Text('Dating',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800])),
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                        color: _isFriendsBorderColorEnabled
                            ? const Color(0xff0E8BFF)
                            : _defaultBorderColor,
                        width: 2.0,
                      )),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide()))),
                  onPressed: () {
                    setState(() {
                      _isFriendsBorderColorEnabled =
                          !_isFriendsBorderColorEnabled;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: const Color(0xff0E8BFF),
                        value: _isFriendsBorderColorEnabled,
                        onChanged: (bool? value) {},
                      ),
                      Text('Making friends',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800])),
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                        color: _isNetworkingBorderColorEnabled
                            ? const Color(0xff09CBC8)
                            : _defaultBorderColor,
                        width: 2.0,
                      )),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide()))),
                  onPressed: () {
                    setState(() {
                      _isNetworkingBorderColorEnabled =
                          !_isNetworkingBorderColorEnabled;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: const Color(0xff09CBC8),
                        value: _isNetworkingBorderColorEnabled,
                        onChanged: (bool? value) {},
                      ),
                      Text('Networking',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800])),
                    ],
                  )),
            ),
            const SizedBox(
              height: 50,
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
                              Navigator.pushNamed(
                                  context, '/onboarding-interests');
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
