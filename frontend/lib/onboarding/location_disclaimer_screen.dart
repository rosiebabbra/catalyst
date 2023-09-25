import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_app/onboarding/interests_screen.dart';

import 'package:permission_handler/permission_handler.dart';

import '../home/home_screen.dart';
import '../widgets/button.dart';

class LocationDisclaimerScreen extends StatefulWidget {
  const LocationDisclaimerScreen({super.key});

  @override
  State<LocationDisclaimerScreen> createState() =>
      _LocationDisclaimerScreenState();
}

class _LocationDisclaimerScreenState extends State<LocationDisclaimerScreen> {
  @override
  Widget build(BuildContext context) {
    var errorMsg = '';
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

    Future<bool> handleLocationPermission() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are enabled');

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
        return false;
      }
      permission = await Geolocator.checkPermission();
      print(permission);
      if (permission == LocationPermission.denied) {
        print('Location services permissions are denied');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print('Location services permissions are denied permanently');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
        return false;
      }
      return true;
    }

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
            ShakeWidget(
                shakeOffset: 3.0,
                child:
                    Text(errorMsg, style: const TextStyle(color: Colors.red))),
            ElevatedButton(
                onPressed: () {
                  var permissionGranted = handleLocationPermission();
                  if (permissionGranted == true) {
                    Navigator.pushNamed(context, '/generating-matches');
                  } else {
                    setState(() {
                      errorMsg = 'We need location access to continue!';
                    });
                  }
                },
                child: Text("Allow access"))
          ]),
        ));
  }
}
