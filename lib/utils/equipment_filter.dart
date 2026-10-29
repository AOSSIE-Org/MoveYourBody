import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/domain/models/user_data.dart';

final equipmentFilterProvider = Provider<EquipmentFilter>((ref) {
  return EquipmentFilter();
});

class EquipmentFilter {
  List<Exercise> filterExercises({
    required List<Exercise> exercises,
    required UserData user,
  }) {
    return exercises.where((exercise) {
      return _hasRequiredEquipments(exercise.equipments, user.equipments);
    }).toList();
  }

  bool _hasRequiredEquipments(
    List<Equipment> exerciseEquipments,
    List<String> userEquipments,
  ) {
    if (exerciseEquipments.isEmpty) {
      return true;
    }

    final availableEquipments = userEquipments.toSet();

    return exerciseEquipments.every(
      (equipment) => availableEquipments.contains(equipment.name),
    );
  }
}
