import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_hunter/core/widgets/holographic_card.dart';

void main() {
  group('HolographicCard Widget Tests', () {
    testWidgets('Renders child content and triggers onTap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HolographicCard(
              onTap: () => tapped = true,
              child: const Text('SYSTEM LOG MATRIX'),
            ),
          ),
        ),
      );

      expect(find.text('SYSTEM LOG MATRIX'), findsOneWidget);

      await tester.tap(find.text('SYSTEM LOG MATRIX'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
