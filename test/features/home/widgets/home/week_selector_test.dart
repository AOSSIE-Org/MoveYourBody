import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:move_your_body/features/home/widgets/home/week_selector.dart';
import 'package:move_your_body/features/home/view_model/home_view_model.dart';
import 'package:move_your_body/features/home/models/home_state.dart';

class FakeHomeViewModel extends HomeViewModel {
  final HomeState initialState;

  FakeHomeViewModel(this.initialState);

  @override
  HomeState build() => initialState;
}

void main() {
  Widget createTestWidget(HomeState state) {
    return ProviderScope(
      overrides: [
        homeViewModelProvider.overrideWith(() => FakeHomeViewModel(state)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: WeekSelector(),
        ),
      ),
    );
  }

  group('WeekSelector', () {
    testWidgets('renders nothing when currentWeekDays is empty', (WidgetTester tester) async {
      final state = HomeState(
        selectedDate: DateTime.now(),
        currentWeekDays: [],
      );

      await tester.pumpWidget(createTestWidget(state));

      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders days and correctly highlights selected day', (WidgetTester tester) async {
      final now = DateTime(2023, 10, 10);
      final weekDays = List.generate(7, (index) => DateTime(2023, 10, 8).add(Duration(days: index)));

      final state = HomeState(
        selectedDate: now,
        currentWeekDays: weekDays,
      );

      await tester.pumpWidget(createTestWidget(state));

      expect(find.byType(ListView), findsOneWidget);
      final dayLabel = DateFormat('E').format(now)[0];
      final dateLabel = DateFormat('d').format(now);
      expect(find.text(dayLabel), findsWidgets);
      expect(find.text(dateLabel), findsOneWidget);
      for (int i = 8; i <= 14; i++) {
        expect(find.text(i.toString()), findsOneWidget);
      }
    });
  });
}
