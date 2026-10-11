import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/exercise_info/info_badges.dart';

void main() {
  group('Info Badges', () {
    testWidgets('ExerciseBadge renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseBadge(
              label: 'TEST BADGE',
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('TEST BADGE'), findsOneWidget);
    });

    testWidgets('MuscleChip renders primary muscle correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MuscleChip(
              label: 'chest_muscle',
              isPrimary: true,
            ),
          ),
        ),
      );

      expect(find.text('chest muscle'), findsOneWidget);
    });
  });
}
