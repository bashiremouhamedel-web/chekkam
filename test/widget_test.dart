import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chekkam/main.dart';

void main() {
  testWidgets('Home screen shows the Chekkam pillars', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ChekkamApp()));
    await tester.pumpAndSettle();

    expect(find.text('Chekkam'), findsOneWidget);
    expect(find.text('Verify Messages & Media'), findsOneWidget);
    expect(find.text('Verify Documents'), findsOneWidget);
  });
}
