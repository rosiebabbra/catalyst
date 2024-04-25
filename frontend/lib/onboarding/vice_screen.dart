import 'dart:math' as math;
import 'package:catalyst/onboarding/career_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

updateVice(User? user, String vice, String selection) async {
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
      vice: selection,
    });
  } else {}
}

class ViceScreen extends StatefulWidget {
  const ViceScreen({super.key});

  @override
  State<StatefulWidget> createState() => ViceScreenState();
}

class ViceScreenState extends State<ViceScreen> {
  var selectedDrinkingValue = 'No';
  var selectedSmokingValue = 'No';
  var selectedMarjiuanaValue = 'No';
  var selectedDrugsValue = 'No';

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.325),
        const CircleAvatar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          radius: 50,
          child: Icon(Icons.wine_bar, size: 50),
        ),
        const SizedBox(height: 15),
        const Text('How do you feel about?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(
          '(Optional)',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 5,
              shrinkWrap: false,
              padding: const EdgeInsets.all(0),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
                  child: Text(
                    'Drinking?',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 75, 0),
                  child: DropdownButton<String>(
                      value: selectedDrinkingValue,
                      items: const [
                        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                        DropdownMenuItem(
                            value: 'Sometimes', child: Text('Sometimes')),
                        DropdownMenuItem(value: 'No', child: Text('No')),
                      ],
                      onChanged: (value) {
                        // Write to db
                        setState(() {
                          selectedDrinkingValue = value.toString();
                        });
                        updateVice(user, 'drinking', selectedDrinkingValue);
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
                  child: Text(
                    'Smoking?',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 75, 0),
                  child: DropdownButton<String>(
                      value: selectedSmokingValue,
                      items: const [
                        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                        DropdownMenuItem(
                            value: 'Sometimes', child: Text('Sometimes')),
                        DropdownMenuItem(value: 'No', child: Text('No')),
                      ],
                      onChanged: (value) {
                        //Write to db
                        setState(() {
                          selectedSmokingValue = value.toString();
                        });
                        updateVice(user, 'smoking', selectedSmokingValue);
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
                  child: Text(
                    'Marijuana?',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 75, 0),
                  child: DropdownButton<String>(
                      value: selectedMarjiuanaValue,
                      items: const [
                        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                        DropdownMenuItem(
                            value: 'Sometimes', child: Text('Sometimes')),
                        DropdownMenuItem(value: 'No', child: Text('No')),
                      ],
                      onChanged: (value) {
                        //Write to db
                        setState(() {
                          selectedMarjiuanaValue = value.toString();
                        });
                        updateVice(user, 'marijuana', selectedMarjiuanaValue);
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
                  child: Text(
                    'Drugs?',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 75, 0),
                  child: DropdownButton<String>(
                      value: selectedDrugsValue,
                      items: const [
                        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                        DropdownMenuItem(
                            value: 'Sometimes', child: Text('Sometimes')),
                        DropdownMenuItem(value: 'No', child: Text('No')),
                      ],
                      onChanged: (value) {
                        //Write to db
                        setState(() {
                          selectedDrugsValue = value.toString();
                        });
                        updateVice(user, 'drugs', selectedDrugsValue);
                      }),
                ),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(225, 0, 0, 0),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CareerScreen()),
                        );
                      }),
                ),
              )),
        )
      ],
    ));
  }
}
