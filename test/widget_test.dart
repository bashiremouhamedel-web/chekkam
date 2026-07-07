import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chekkam/main.dart';

void main() {
  testWidgets('Home screen shows the intent-first Chekkam actions', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ChekkamApp()));
    await tester.pumpAndSettle();

    expect(find.text('Chekkam'), findsOneWidget);
    expect(find.text('Paste a message, a link, or forward it from WhatsApp.'), findsOneWidget);
    expect(find.text('Verify a document'), findsOneWidget);
    expect(find.text('Public alerts'), findsOneWidget);
  });
}
