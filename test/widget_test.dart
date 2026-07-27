import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_voguex_4/main.dart';

void main() {
  testWidgets('VogueX App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VogueXApp());

    // Verify that our main title V O G U E X exists on the initial screen.
    expect(find.text('V O G U E X'), findsOneWidget);

    // Advance the mock network call timer (700ms) to let the initial load complete
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
  });
}
