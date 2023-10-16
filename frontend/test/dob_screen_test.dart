import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/onboarding/dob_screen.dart';
import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Surface error if only one date digit is input',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester.pumpWidget(const MaterialApp(home: DOBEntryScreen()));
    await widgetTester.pumpAndSettle();
  });

  testWidgets('Surface error if almost all date digits are input',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester.pumpWidget(const MaterialApp(home: DOBEntryScreen()));
    await widgetTester.pumpAndSettle();
  });
}
