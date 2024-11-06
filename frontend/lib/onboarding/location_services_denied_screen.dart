import 'package:catalyst/onboarding/image_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:catalyst/utils/text_fade.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:catalyst/utils/utils.dart';

class LocationServiceDeniedScreen extends StatefulWidget {
  final String versionId;
  const LocationServiceDeniedScreen({super.key, required this.versionId});

  @override
  State<LocationServiceDeniedScreen> createState() =>
      LocationServiceDeniedScreenState();
}

class LocationServiceDeniedScreenState
    extends State<LocationServiceDeniedScreen> with WidgetsBindingObserver {
  PermissionStatus currentStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<LocationPermission> getPermissionStatus() async {
    LocationPermission status = await Geolocator.requestPermission();
    return status;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // When the app page is returned to from Settings,
    // re-check whether permission was granted and set state
    if (state == AppLifecycleState.resumed) {
      LocationPermission currentStatus = await getPermissionStatus();
      if (currentStatus == LocationPermission.always ||
          currentStatus == LocationPermission.whileInUse) {
        if (widget.versionId == 'beta') {
          Navigator.pushNamed(context, '/coming-soon');
        } else {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final currentUserId = user?.uid;

          Position? position = await Geolocator.getCurrentPosition();

          writeData('users', 'user_id', currentUserId.toString(), 'location',
              GeoPoint(position.latitude, position.longitude));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageUpload()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getPermissionStatus(),
          builder: (context, snapshot) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xff7301E4),
                          Color(0xff0E8BFF),
                          Color(0xff09CBC8),
                          Color(0xff33D15F),
                        ],
                        stops: [0.0, 0.25, 0.5, 0.75],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: FadeInText(
                        child: Text(
                          'Whoops!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 52.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FadeInText(
                    delayStart: const Duration(milliseconds: 500),
                    child: Text(
                      'Location access is required.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: FadeInText(
                      delayStart: const Duration(seconds: 1),
                      child: Text(
                        'Please allow permissions in your app settings and return to continue.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]);
          }),
    );
  }
}
