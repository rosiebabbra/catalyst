import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'dart:math' as math;

List<GenderIdentification> otherGenderIdentifications = [
  GenderIdentification(id: 1, gender: 'Transgender'),
  GenderIdentification(id: 2, gender: 'Genderqueer/Gender Non-Conforming'),
  GenderIdentification(id: 3, gender: 'Questioning'),
];

class GenderIdentification {
  int id;
  String gender;

  GenderIdentification({required this.id, required this.gender});
}

class GenderIDEntryScreen extends StatefulWidget {
  const GenderIDEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GenderIDEntryScreen> createState() => _GenderIDEntryScreenState();
}

class _GenderIDEntryScreenState extends State<GenderIDEntryScreen> {
  bool maleChecked = false;
  bool femaleChecked = false;
  bool nonBinaryChecked = false;
  bool agenderChecked = false;
  bool genderNCChecked = false;
  bool preferNotToSayChecked = false;
  bool otherChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 25,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.perm_identity, size: 50)),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text("Which of the following best describes you?",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 25),
          child: Text(
              'This will appear on your profile. You will have the option to change it later if you wish.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: femaleChecked,
                    onChanged: (value) {
                      setState(() {
                        femaleChecked = value!;
                      });
                    },
                  ),
                  Text('Woman ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                  Text('(she/her)',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: maleChecked,
                    onChanged: (value) {
                      setState(() {
                        maleChecked = value!;
                      });
                    },
                  ),
                  Text('Man ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                  Text('(he/him)',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: nonBinaryChecked,
                    onChanged: (value) {
                      setState(() {
                        nonBinaryChecked = value!;
                      });
                    },
                  ),
                  Text('Non binary ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                  Text('(they/them)',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: agenderChecked,
                    onChanged: (value) {
                      setState(() {
                        agenderChecked = value!;
                      });
                    },
                  ),
                  Text("Agender ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                  Text('(they/them)',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: genderNCChecked,
                    onChanged: (value) {
                      setState(() {
                        genderNCChecked = value!;
                      });
                    },
                  ),
                  Text("Gender non-conforming ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                  Text('(they/them)',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500))
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: preferNotToSayChecked,
                    onChanged: (value) {
                      setState(() {
                        preferNotToSayChecked = value!;
                      });
                    },
                  ),
                  Text('Prefer not to state',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800]))
                ],
              ),
              if (otherChecked == true)
                MultipleSearchSelection(
                  noResultsWidget: const Text('No results'),
                  showClearAllButton: false,
                  items: otherGenderIdentifications,
                  pickedItemBuilder: (genderIdentification) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(genderIdentification.gender),
                      ),
                    );
                  },
                  fieldToCheck: (c) {
                    return c.gender;
                  },
                  itemBuilder: (genderIdentification, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 12,
                          ),
                          child: Text(genderIdentification.gender),
                        ),
                      ),
                    );
                  },
                )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
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
                        border:
                            Border.all(width: 3.5, color: Colors.transparent),
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
                          Navigator.pushNamed(context, '/location-disclaimer');
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
