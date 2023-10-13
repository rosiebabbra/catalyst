import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/onboarding/dob_screen.dart';
import 'package:my_app/onboarding/gender_identification_screen.dart';
import 'package:my_app/onboarding/name_screen.dart';
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

    // Only enter first birthdate digit
    await widgetTester.enterText(find.byType(TextFormField).first, '0');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Assert error message surfaces
    expect(
        find.text('Please enter a date in MM-DD-YY format.'), findsOneWidget);
  });

  testWidgets('Surface error if almost all date digits are input',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester.pumpWidget(const MaterialApp(home: DOBEntryScreen()));
    await widgetTester.pumpAndSettle();

    // Enter almost all digits
    await widgetTester.sendKeyEvent(LogicalKeyboardKey.digit0);
    await widgetTester.sendKeyEvent(LogicalKeyboardKey.digit4);
    await widgetTester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await widgetTester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await widgetTester.sendKeyEvent(LogicalKeyboardKey.digit9);
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Assert error message surfaces
    expect(
        find.text('Please enter a date in MM-DD-YY format.'), findsOneWidget);
  });

  // TODO: Write test to "Expect birth year is calculated correctly"
}
