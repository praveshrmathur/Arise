import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_hunter/core/constants/rank_constants.dart';
import 'package:project_hunter/core/widgets/rank_badge.dart';

void main() {
  group('RankBadge Widget Tests', () {
    testWidgets('Renders Rank E badge code and title properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: RankBadge(
                rank: HunterRank.e,
                showTitle: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('E'), findsOneWidget);
      expect(find.text('RANK E'), findsOneWidget);
      expect(find.text('Rookie'), findsOneWidget);
    });

    testWidgets('Renders Rank S badge code properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: RankBadge(
                rank: HunterRank.s,
                showTitle: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('S'), findsOneWidget);
      expect(find.text('RANK S'), findsOneWidget);
      expect(find.text('Legendary'), findsOneWidget);
    });
  });
}
