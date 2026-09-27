import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_animation_box.dart';
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

  group('ExecutionAnimationBox', () {
    late MockExercise currentExercise;
    late MockExercise nextExercise;

    setUp(() {
      currentExercise = MockExercise();
      when(() => currentExercise.exerciseId).thenReturn('current');
      when(() => currentExercise.isLottie).thenReturn(true);
      when(() => currentExercise.animationLink).thenReturn('');

      nextExercise = MockExercise();
      when(() => nextExercise.exerciseId).thenReturn('next');
      when(() => nextExercise.isLottie).thenReturn(true);
      when(() => nextExercise.animationLink).thenReturn('');
    });

    Widget createTestWidget(bool isResting, MockExercise? nextEx) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ExecutionAnimationBox(
              exercise: currentExercise,
              isResting: isResting,
              nextExercise: nextEx,
            ),
          ),
        ),
      );
    }

    testWidgets('shows current exercise animation when not resting', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(false, nextExercise));
      final animationPreview = find.byType(AnimationPreview);
      expect(animationPreview, findsOneWidget);

      final previewWidget = tester.widget<AnimationPreview>(animationPreview);
      expect(previewWidget.exercise.exerciseId, 'current');
    });

    testWidgets('shows next exercise animation when resting and next is not null', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(true, nextExercise));
      
      final animationPreview = find.byType(AnimationPreview);
      expect(animationPreview, findsOneWidget);

      final previewWidget = tester.widget<AnimationPreview>(animationPreview);
      expect(previewWidget.exercise.exerciseId, 'next');
    });

    testWidgets('shows coffee icon when resting and next is null (session end)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(true, null));
      expect(find.byType(AnimationPreview), findsNothing);
      expect(find.byIcon(Icons.coffee), findsOneWidget);
    });
  });
}
