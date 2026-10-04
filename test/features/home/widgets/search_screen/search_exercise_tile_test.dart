import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/widgets/search_screen/search_exercise_tile.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

class MockExercise extends Mock implements Exercise {}

void main() {
  testWidgets('SearchExerciseTile renders exercise info correctly', (WidgetTester tester) async {
    final mockExercise = MockExercise();
    when(() => mockExercise.name).thenReturn('Push Ups');
    when(() => mockExercise.difficulty).thenReturn(Difficulty.intermediate);
    when(() => mockExercise.bodyRegions).thenReturn([BodyRegion.upperBody]);

    bool infoTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchExerciseTile(
            exercise: mockExercise,
            onInfoTap: () => infoTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Push Ups'), findsOneWidget);
    expect(find.text('INTERMEDIATE'), findsOneWidget);
    expect(find.text('UPPER BODY'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.info_outline_rounded));
    expect(infoTapped, isTrue);
  });
}
