import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'dart:math' as math;

enum Identity {
  woman,
  man,
  nonBinary,
  agender,
  genderNonconforming,
  preferNotToSay,
  unselected
}

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
  Identity? selectedGender = Identity.unselected;
  var errorMsg = '';

  updateUserGender(User? user, String genderIdentity) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: user?.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assume there's only one matching document (you might need to adjust if multiple documents match)
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // Get the document reference and update the fields
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(documentSnapshot.id);

      // Update the fields
      await documentReference.update({
        'gender': genderIdentity,
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.diversity_1_outlined, size: 30))),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text("Which of the following best describes you?",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
          child: Text(
              'This will appear on your profile. You will have the option to change it later if you wish.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    value: Identity.woman,
                    groupValue: selectedGender,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff33D15F);
                      } else {
                        return Colors.grey[800] ?? Colors.grey;
                      }
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
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
                  Radio(
                    value: Identity.man,
                    groupValue: selectedGender,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff33D15F);
                      } else {
                        return Colors.grey[800] ?? Colors.grey;
                      }
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
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
                  Radio(
                    value: Identity.nonBinary,
                    groupValue: selectedGender,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff33D15F);
                      } else {
                        return Colors.grey[800] ?? Colors.grey;
                      }
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
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
                  Radio(
                    value: Identity.agender,
                    groupValue: selectedGender,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff33D15F);
                      } else {
                        return Colors.grey[800] ?? Colors.grey;
                      }
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
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
                  Radio(
                    value: Identity.genderNonconforming,
                    groupValue: selectedGender,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff33D15F);
                      } else {
                        return Colors.grey[800] ?? Colors.grey;
                      }
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
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
                  Radio(
                    value: Identity.preferNotToSay,
                    groupValue: selectedGender,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff33D15F);
                      } else {
                        return Colors.grey[800] ?? Colors.grey;
                      }
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
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
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(37.5, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (errorMsg.isNotEmpty)
                const Icon(
                  Icons.info_outline,
                  color: Colors.red,
                ),
              if (errorMsg.isNotEmpty) const Text(' '),
              Expanded(
                child: Text(errorMsg,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
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
                          Map<Identity, String> identityOptions = {
                            Identity.man: 'Male',
                            Identity.woman: 'Female',
                            Identity.agender: 'Agender',
                            Identity.genderNonconforming:
                                'Gender non-conforming',
                            Identity.nonBinary: 'Non-binary',
                            Identity.preferNotToSay: 'Prefer not to state',
                          };

                          // Write identities to db
                          FirebaseAuth auth = FirebaseAuth.instance;
                          User? currentUser = auth.currentUser;

                          if (selectedGender != Identity.unselected) {
                            updateUserGender(currentUser,
                                identityOptions[selectedGender].toString());
                            Navigator.pushNamed(
                                context, '/location-disclaimer');
                          } else {
                            setState(() {
                              errorMsg = 'Please select at least one option.';
                            });
                          }
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
