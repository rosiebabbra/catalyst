import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

updateOccupation(User? user, String selection) async {
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
      'occupation': selection,
    });
  } else {}
}

class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});

  @override
  State<StatefulWidget> createState() => CareerScreenState();
}

class CareerScreenState extends State<CareerScreen> {
  String occupation = 'Agriculture';

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
            child: Icon(Icons.work, size: 50),
          ),
          const SizedBox(height: 15),
          const Text('Career',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('Please select your occupation.',
              style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          const SizedBox(height: 25),
          DropdownButton<String>(
              value: occupation,
              menuMaxHeight: 250,
              items: const [
                DropdownMenuItem(
                    value: 'Advertising and marketing',
                    child: Text('Advertising and marketing')),
                DropdownMenuItem(value: 'Aerospace', child: Text('Aerospace')),
                DropdownMenuItem(
                    value: 'Agriculture', child: Text('Agriculture')),
                DropdownMenuItem(
                    value: 'Computer and technology',
                    child: Text('Computer and technology')),
                DropdownMenuItem(
                    value: 'Construction', child: Text('Construction')),
                DropdownMenuItem(value: 'Education', child: Text('Education')),
                DropdownMenuItem(value: 'Energy', child: Text('Energy')),
                DropdownMenuItem(
                    value: 'Entertainment', child: Text('Entertainment')),
                DropdownMenuItem(value: 'Fashion', child: Text('Fashion')),
                DropdownMenuItem(
                    value: 'Finance and economic',
                    child: Text('Finance and economic')),
                DropdownMenuItem(
                    value: 'Healthcare', child: Text('Healthcare')),
                DropdownMenuItem(
                    value: 'Hospitality', child: Text('Hospitality')),
                DropdownMenuItem(
                    value: 'Manufacturing', child: Text('Manufacturing')),
                DropdownMenuItem(value: 'Service', child: Text('Service')),
                DropdownMenuItem(
                    value: 'Media and news', child: Text('Media and news')),
                DropdownMenuItem(
                    value: 'Telecommunication',
                    child: Text('Telecommunication')),
              ],
              onChanged: (value) {
                // Write to db
                setState(() {
                  occupation = value.toString();
                });
                updateOccupation(user, occupation);
              }),
          const SizedBox(height: 175),
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
