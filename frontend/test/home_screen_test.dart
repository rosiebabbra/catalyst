import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/home/home_screen.dart';

void main() {
  testWidgets('Expected home screen elements',
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const HomeScreen());
  });

  // Tap the '+' icon and trigger a frame.
  // await tester.tap(find.byIcon(Icons.add));
  // await tester.pump();
}
