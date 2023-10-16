import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/onboarding/dob_screen.dart';
import 'package:my_app/onboarding/gender_identification_screen.dart';
import 'package:my_app/onboarding/location_disclaimer_screen.dart';
import 'package:my_app/onboarding/name_screen.dart';
import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Surface error message if no option is selected',
      (WidgetTester widgetTester) async {
    await widgetTester
        .pumpWidget(MaterialApp(home: const GenderIDEntryScreen(), routes: {
      '/location-disclaimer': (context) =>
          const LocationDisclaimerScreen(versionId: 'beta')
    }));

    // Click next button without selecting an option
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    expect(find.text('Please select at least one option.'), findsOneWidget);
  });

  testWidgets('Navigate to location screen once an option is selected',
      (WidgetTester widgetTester) async {
    await widgetTester
        .pumpWidget(MaterialApp(home: const GenderIDEntryScreen(), routes: {
      '/location-disclaimer': (context) =>
          const LocationDisclaimerScreen(versionId: 'beta')
    }));

    // Select first option
    await widgetTester.tap(find.byType(Checkbox).first);
    await widgetTester.pumpAndSettle();

    // Click next button
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();

    expect(find.text('Location access'), findsOneWidget);
  });
}
