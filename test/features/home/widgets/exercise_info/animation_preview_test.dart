import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/ui/home/widgets/exercise_info/animation_preview.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockExercise extends Mock implements Exercise {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(Lottie.cache.clear);

  testWidgets('preloads each lottie composition once', (
    WidgetTester tester,
  ) async {
    final mockExercise = MockExercise();
    when(() => mockExercise.exerciseId).thenReturn('Ex15');
    when(() => mockExercise.isLottie).thenReturn(true);

    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.runAsync(
      () => preloadExerciseAnimations(context, [mockExercise, mockExercise]),
    );

    expect(Lottie.cache.count, 1);
  });

  testWidgets('parses lottie assets in the background', (
    WidgetTester tester,
  ) async {
    final mockExercise = MockExercise();
    when(() => mockExercise.exerciseId).thenReturn('Ex15');
    when(() => mockExercise.isLottie).thenReturn(true);
    when(() => mockExercise.animationLink).thenReturn('');

    await tester.runAsync(
      () => AssetLottie(
        'assets/animations/Ex15.json',
        backgroundLoading: true,
      ).load(),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: AnimationPreview(exercise: mockExercise)),
        ),
      ),
    );

    final animation = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
    final provider = animation.lottie as AssetLottie;

    expect(provider.assetName, 'assets/animations/Ex15.json');
    expect(provider.backgroundLoading, isTrue);
  });

  testWidgets('AnimationPreview renders lottie placeholder for missing file', (
    WidgetTester tester,
  ) async {
    final mockExercise = MockExercise();
    when(() => mockExercise.exerciseId).thenReturn('test_exercise');
    when(() => mockExercise.isLottie).thenReturn(true);
    when(() => mockExercise.animationLink).thenReturn('');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: AnimationPreview(exercise: mockExercise)),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Animation not available'), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center_rounded), findsOneWidget);
  });
}
