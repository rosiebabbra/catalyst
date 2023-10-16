import 'package:cloud_firestore/cloud_firestore.dart';

import 'mock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/beta/coming_soon_screen.dart';
import 'package:my_app/onboarding/location_disclaimer_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';

abstract class LocationService {
  Future<LocationPermission> requestPermission();
  Future<Position> getCurrentPosition();
}

class GeolocatorService implements LocationService {
  @override
  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  @override
  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition();
  }
}

class MockLocationService extends Mock implements LocationService {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // testWidgets('Navigate to coming soon screen once an option is selected',
  //     (WidgetTester widgetTester) async {
  //   await widgetTester.pumpWidget(MaterialApp(
  //       home: const LocationDisclaimerScreen(
  //         versionId: 'beta',
  //       ),
  //       routes: {'/coming-soon': (context) => const ComingSoonScreen()}));

  //   // Mock the Geolocator.requestPermission() function to allow access; in the next test, mock to denied
  //   final locationService = MockLocationService();

  //   when(locationService.requestPermission())
  //       .thenReturn(Future.value(LocationPermission.always));
  //   when(locationService.getCurrentPosition())
  //       .thenReturn(Future.value(Future.value(GeoPoint(
  //     latitude: 34.0522,
  //     longitude: -118.2437,
  //     timestamp: DateTime.now(),
  //   ))));

  //   // Click "Enable location access" button
  //   await widgetTester.tap(find.byType(CupertinoButton));
  //   await widgetTester.pumpAndSettle();

  //   expect(find.text('Enable notifications'), findsOneWidget);
  // });
}
