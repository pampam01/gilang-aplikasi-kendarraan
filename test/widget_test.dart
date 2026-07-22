import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kendaraan_aset/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    // Wait for splash screen or any initial navigation
    await tester.pumpAndSettle();

    // Just verify the app widget loads without throwing
    expect(find.byType(App), findsOneWidget);
  });
}
