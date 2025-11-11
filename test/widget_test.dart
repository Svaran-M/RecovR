import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rehab_tracker_pro/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: RehabTrackerProApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('RehabTracker Pro'), findsWidgets);
    expect(find.text('Project structure initialized'), findsOneWidget);
  });
}
