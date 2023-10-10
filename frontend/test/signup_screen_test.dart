import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/onboarding/name_screen.dart';
import 'package:my_app/onboarding/signup_screen.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'mock.dart';

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Expected email invalid error',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester.pumpWidget(const MaterialApp(home: SignupScreen()));
    await widgetTester.pumpAndSettle();

    // Enter incorrectly formatted email
    await widgetTester.enterText(
        find.byType(TextField).first, 'some-invalid-email');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Test invalid email address error appears
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
  });
  testWidgets('Expected password length error',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester.pumpWidget(const MaterialApp(home: SignupScreen()));
    await widgetTester.pumpAndSettle();

    // Enter invalid length password
    await widgetTester.enterText(find.byType(TextField).at(1), 'blah');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Test invalid email address error appears
    expect(find.text('Your password must be at least 8 characters long.'),
        findsOneWidget);
  });

  testWidgets('Expected unmatching passwords error',
      (WidgetTester widgetTester) async {
    // Render screen
    await widgetTester.pumpWidget(const MaterialApp(home: SignupScreen()));
    await widgetTester.pumpAndSettle();

    // Enter password
    await widgetTester.enterText(find.byType(TextField).at(1), 'blah');
    await widgetTester.pumpAndSettle();

    // Re-enter password incorrectly
    await widgetTester.enterText(find.byType(TextField).last, 'blahblahblah');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Test invalid email address error appears
    expect(find.text('The entered passwords do not match.'), findsOneWidget);
  });

  testWidgets('Expected navigation on button push',
      (WidgetTester widgetTester) async {
    // Mock the Firebase client; it wasn't necessary in
    // the other tests because since the errors were being
    // hit, the db write was not happening.

    const testEmail = 'testing@somecrap.com';
    const testPassword = 'alright,alright,alright';

    // Mock the behavior of createUserWithEmailAndPassword
    // Create an instance of the mock class
    final authService = MockFirebaseAuth();

    // Define the behavior of the mocked function
    when(authService.createUserWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
    ));

    // Render screen
    await widgetTester.pumpWidget(MaterialApp(home: SignupScreen(), routes: {
      '/onboarding-name': (context) => const NameEntryScreen(),
    }));
    await widgetTester.pumpAndSettle();

    // Enter email
    await widgetTester.enterText(find.byType(TextField).first, testEmail);
    await widgetTester.pumpAndSettle();

    // Enter password
    await widgetTester.enterText(find.byType(TextField).at(1), testPassword);
    await widgetTester.pumpAndSettle();

    // Re-enter password
    await widgetTester.enterText(find.byType(TextField).last, testPassword);
    await widgetTester.pumpAndSettle();

    // Tap next button
    await widgetTester.tap(find.byType(TextButton).last);
    await widgetTester.pumpAndSettle();

    // Assert that next page was reached
    expect(find.text("What's your first name?"), findsOneWidget);
  });
}
