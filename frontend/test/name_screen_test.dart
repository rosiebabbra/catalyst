import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/onboarding/name_screen.dart';
import 'package:my_app/onboarding/signup_screen.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Expected non empty string input',
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
    expect(find.text('This is how your name will appear on your profile.'),
        findsOneWidget);
  });
}
