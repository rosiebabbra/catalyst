import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

updateReligion(User? user, String selection) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('user_id', isEqualTo: user?.uid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Assume there's only one matching document (you might need to adjust if multiple documents match)
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

    // Get the document reference and update the fields
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(documentSnapshot.id);

    // Update the fields
    await documentReference.update({
      'religious_pref': selection,
    });
  } else {}
}

class ReligiousPreferenceScreen extends StatefulWidget {
  const ReligiousPreferenceScreen({super.key});

  @override
  State<StatefulWidget> createState() => ReligiousPreferenceScreenState();
}

class ReligiousPreferenceScreenState extends State<ReligiousPreferenceScreen> {
  String selected = 'Agnostic';
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.325),
          const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            radius: 50,
            child: Icon(Icons.auto_awesome_outlined, size: 50),
          ),
          const SizedBox(height: 15),
          const Text('Religious Beliefs',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Text('Please select your religious beliefs, if any.',
              style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          const SizedBox(height: 5),
          Text('(Optional)',
              style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          const SizedBox(height: 25),
          DropdownButton<String>(
              value: selected,
              menuMaxHeight: 250,
              items: const [
                DropdownMenuItem(value: 'Agnostic', child: Text('Agnostic')),
                DropdownMenuItem(value: 'Atheist', child: Text('Atheist')),
                DropdownMenuItem(value: 'Buddhist', child: Text('Buddhist')),
                DropdownMenuItem(value: 'Catholic', child: Text('Catholic')),
                DropdownMenuItem(value: 'Christian', child: Text('Christian')),
                DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
                DropdownMenuItem(value: 'Jewish', child: Text('Jewish')),
                DropdownMenuItem(value: 'Muslim', child: Text('Muslim')),
                DropdownMenuItem(value: 'Sikh', child: Text('Sikh')),
                DropdownMenuItem(value: 'Spiritual', child: Text('Spiritual')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
                DropdownMenuItem(
                    value: 'Prefer not to say',
                    child: Text('Prefer not to say')),
              ],
              onChanged: (value) {
                // Write to db
                setState(() {
                  selected = value.toString();
                  updateReligion(user, value.toString());
                });
              }),
          const SizedBox(height: 150),
          Padding(
            padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
            child: SizedBox(
                height: 75,
                width: 75,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3.5, color: Colors.transparent),
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
                          Navigator.pushNamed(context, '/hobbies');
                        }),
                  ),
                )),
          )
        ],
      ),
    ));
  }
}
