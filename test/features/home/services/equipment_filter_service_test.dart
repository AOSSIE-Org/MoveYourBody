import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/services/equipment_filter_service.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/user_data.dart';

class MockExercise extends Mock implements Exercise {}
class MockUserData extends Mock implements UserData {}

void main() {
  group('EquipmentFilterService', () {
    late EquipmentFilterService service;

    setUp(() {
      service = EquipmentFilterService();
    });

    test('returns all exercises if none require equipment', () {
      final user = MockUserData();
      when(() => user.equipments).thenReturn([]);

      final ex1 = MockExercise();
      when(() => ex1.equipments).thenReturn([]);
      final ex2 = MockExercise();
      when(() => ex2.equipments).thenReturn([]);

      final result = service.filterExercises(
        exercises: [ex1, ex2],
        user: user,
      );

      expect(result.length, 2);
    });

    test('filters out exercises requiring missing equipment', () {
      final user = MockUserData();
      when(() => user.equipments).thenReturn(['dumbbells']);

      final exWithDumbbells = MockExercise();
      when(() => exWithDumbbells.equipments).thenReturn([Equipment.dumbbells]);

      final exWithBench = MockExercise();
      when(() => exWithBench.equipments).thenReturn([Equipment.bench]);

      final exNoEquip = MockExercise();
      when(() => exNoEquip.equipments).thenReturn([]);

      final result = service.filterExercises(
        exercises: [exWithDumbbells, exWithBench, exNoEquip],
        user: user,
      );

      expect(result.length, 2);
      expect(result.contains(exWithDumbbells), isTrue);
      expect(result.contains(exNoEquip), isTrue);
      expect(result.contains(exWithBench), isFalse);
    });
  });
}
