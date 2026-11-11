import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:move_your_body/ui/home/widgets/screens/session_feedback_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<LottieComposition> loadConfetti(WidgetTester tester) async {
  final composition = await tester.runAsync(
    () => AssetLottie(
      'assets/animations/Confetti.json',
      backgroundLoading: true,
    ).load(),
  );
  return composition!;
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(Lottie.cache.clear);

  testWidgets('SessionFeedbackScreen builds successfully', (
    WidgetTester tester,
  ) async {
    await loadConfetti(tester);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SessionFeedbackScreen(sessionId: 1)),
      ),
    );

    expect(find.byType(SessionFeedbackScreen), findsOneWidget);
  });

  testWidgets('confetti uses native duration and the display frame rate', (
    WidgetTester tester,
  ) async {
    final composition = await loadConfetti(tester);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SessionFeedbackScreen(sessionId: 1)),
      ),
    );

    final finder = find.byWidgetPredicate(
      (widget) =>
          widget is LottieBuilder &&
          widget.lottie is AssetLottie &&
          (widget.lottie as AssetLottie).assetName ==
              'assets/animations/Confetti.json',
    );
    final animation = tester.widget<LottieBuilder>(finder);
    final provider = animation.lottie as AssetLottie;

    expect(provider.backgroundLoading, isTrue);
    expect(animation.frameRate, FrameRate.max);

    animation.onLoaded!(composition);

    final controller = animation.controller! as AnimationController;
    expect(controller.duration, composition.duration);
  });
}
