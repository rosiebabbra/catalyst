import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import '../home/home_screen.dart';
import '../widgets/button.dart';

class LocationDisclaimerScreen extends StatelessWidget {
  const LocationDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Allow "hatched" to access your location?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Approve',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

// Add some nice animations/transitioning here
    return Scaffold(
        // TODO: Remove appbar for user, keep for admin/dev
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              'In order to use hatched, we need access to your location.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 35),
            const Text(
              'Your exact location will never be shared with potential matches.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const StandardButton(
                destination: '/generating-matches', buttonText: "Allow access")
          ]),
        ));
  }
}
