// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';
import 'package:my_app/utils/text_fade.dart';
import 'package:my_app/widgets/button.dart';

void main() {
  testWidgets('Expected main screen elements',
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: MyApp(
        versionId: 'beta',
        useVideoAsset: false,
      ),
    ));

    // Verify that the title appears
    expect(
        find.descendant(
          of: find.byType(FadeInText),
          matching: find.text('catalyst'),
        ),
        findsOneWidget);

    // Assert account creation button exists
    expect(
        find.descendant(
          of: find.byType(AnimatedButton),
          matching: find.text('Create account'),
        ),
        findsOneWidget);

    // Assert sign in link exists
    expect(find.text('Sign in', findRichText: true), findsOneWidget);

    // Test navigation to correct pages
    await widgetTester.tap(find.descendant(
      of: find.byType(AnimatedButton),
      matching: find.text('Create account'),
    ));
    await widgetTester.pumpAndSettle();

    // Assert that the tap event lands on the correct page
    expect(find.text('Re-enter your password'), findsOneWidget);
  });
}
