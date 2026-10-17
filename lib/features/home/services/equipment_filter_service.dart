import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/user_data.dart';

final equipmentFilterServiceProvider = Provider<EquipmentFilterService>((ref) {
  return EquipmentFilterService();
});

class EquipmentFilterService {
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
