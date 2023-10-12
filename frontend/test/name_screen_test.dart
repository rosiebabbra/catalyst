import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/onboarding/dob_screen.dart';
import 'package:my_app/onboarding/name_screen.dart';
import 'package:my_app/onboarding/signup_screen.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Expect non empty string input',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester.pumpWidget(const MaterialApp(home: NameEntryScreen()));
    await widgetTester.pumpAndSettle();

    // Enter empty string in name field
    await widgetTester.enterText(find.byType(TextField).first, '');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Test invalid email address error appears
    expect(find.text('Please enter a name to continue.'), findsOneWidget);
  });

  testWidgets(
      'More unconventional names can register (looking at you, X Æ A-Xii)',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester
        .pumpWidget(MaterialApp(home: const NameEntryScreen(), routes: {
      '/onboarding-dob': (context) => const DOBEntryScreen(),
    }));
    await widgetTester.pumpAndSettle();

    // Enter a name with weird characters
    await widgetTester.enterText(find.byType(TextField).first, 'X Æ A-Xii');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Test that the next page appears, so that the user was allowed to register
    expect(find.text('Your birthday?'), findsOneWidget);
  });
}
