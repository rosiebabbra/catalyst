import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Surface error if only one date digit is input',
      (WidgetTester widgetTester) async {});

  testWidgets('Surface error if almost all date digits are input',
      (WidgetTester widgetTester) async {});
}
