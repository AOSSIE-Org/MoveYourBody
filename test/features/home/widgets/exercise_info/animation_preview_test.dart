import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/home/widgets/exercise_info/animation_preview.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockExercise extends Mock implements Exercise {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('AnimationPreview renders lottie placeholder for missing file', (WidgetTester tester) async {
    final mockExercise = MockExercise();
    when(() => mockExercise.exerciseId).thenReturn('test_exercise');
    when(() => mockExercise.isLottie).thenReturn(true);
    when(() => mockExercise.animationLink).thenReturn('');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AnimationPreview(exercise: mockExercise),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    expect(find.text('Animation not available'), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center_rounded), findsOneWidget);
  });
}
