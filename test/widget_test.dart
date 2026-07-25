import 'package:factory_management/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App should load dashboard', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the dashboard is shown by looking for the welcome text
    expect(find.textContaining('Welcome back'), findsOneWidget);
  });
}
