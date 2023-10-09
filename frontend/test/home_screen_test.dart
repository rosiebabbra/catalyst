import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/onboarding/signup_screen.dart';

void main() {
  testWidgets('Expected email invalid error',
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: SignupScreen()));
    await widgetTester.pumpAndSettle();

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
    await widgetTester.pumpWidget(const MaterialApp(home: SignupScreen()));
    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(find.byType(TextField).at(1), 'blah');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Test invalid email address error appears
    expect(find.text('Your password must be at least 8 characters long.'),
        findsOneWidget);
  });

  testWidgets('Expected password length error',
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: SignupScreen()));
    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(find.byType(TextField).at(1), 'blah');
    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(find.byType(TextField).last, 'blahblahblah');
    await widgetTester.pumpAndSettle();

    // Press next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    // Test invalid email address error appears
    expect(find.text('The entered passwords do not match.'), findsOneWidget);
  });
}
