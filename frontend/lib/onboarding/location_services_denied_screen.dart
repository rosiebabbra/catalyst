import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_app/utils/text_fade.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServiceDeniedScreen extends StatefulWidget {
  final versionId;
  const LocationServiceDeniedScreen({super.key, required this.versionId});

  @override
  State<LocationServiceDeniedScreen> createState() =>
      LocationServiceDeniedScreenState();
}

class LocationServiceDeniedScreenState
    extends State<LocationServiceDeniedScreen> {
  var currentStatus;

  @override
  Widget build(BuildContext context) {
    Future<PermissionStatus> getPermissionStatus() async {
      PermissionStatus status = await Permission.location.status;
      return status;
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            elevation: 200,
            context: context,
            builder: (BuildContext context) {
              return FutureBuilder<PermissionStatus>(
                future: getPermissionStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the future is still running
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If there was an error
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return BottomSheet(
                      elevation: 200,
                      onClosing: () async {
                        var status = await Geolocator.checkPermission();
                        setState(() {
                          currentStatus = status;
                        });

                        if (status == LocationPermission.always ||
                            status == LocationPermission.whileInUse) {
                          if (widget.versionId == 'beta') {
                            Navigator.pushNamed(context, '/coming-soon');
                          } else {
                            Navigator.pushNamed(context, '/generating-matches');
                          }
                        }
                      },
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(25, 50, 25, 50),
                          child: Text(
                              'Current status: ${currentStatus.toString()}',
                              style: const TextStyle(fontSize: 18)),
                        );
                      },
                    );
                  }
                },
              );
            },
          );
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        ]),
      ),
    );
  }
}
