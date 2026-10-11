import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

void main() {
  group('Exercise Model Tests', () {
    const exercise = Exercise(
      exerciseId: 'ex_1',
      name: 'Push Up',
      type: ExerciseType.bodyweight,
      primaryMuscles: ['Chest', 'Triceps'],
      secondaryMuscles: ['Shoulders', 'Core'],
      bodyRegions: [BodyRegion.upperBody, BodyRegion.core],
      movementPattern: 'Push',
      difficulty: Difficulty.beginner,
      intensity: Intensity.moderate,
      goalTags: ['Strength', 'Upper Body'],
      estimatedTime: 30,
      overview: 'Standard push up',
      benefits: 'Builds upper body strength',
      contraindications: ['Wrist injury'],
      instructions: 'Keep body straight and lower chest.',
      isLottie: true,
      equipments: [Equipment.yogaMat],
      animationLink: 'https://example.com/pushup.json',
    );

    test('toMap converts Exercise instance correctly', () {
      final map = exercise.toMap();

      expect(map['exercise_id'], 'ex_1');
      expect(map['name'], 'Push Up');
      expect(map['type'], 'bodyweight');
      expect(map['difficulty'], 'beginner');
      expect(map['intensity'], 'moderate');
      expect(map['is_lottie'], 1);
      expect(map['animation_link'], 'https://example.com/pushup.json');
    });

    test('fromMap parses map produced by toMap accurately', () {
      final map = exercise.toMap();
      final parsed = Exercise.fromMap(map);

      expect(parsed.exerciseId, exercise.exerciseId);
      expect(parsed.name, exercise.name);
      expect(parsed.type, exercise.type);
      expect(parsed.primaryMuscles, exercise.primaryMuscles);
      expect(parsed.secondaryMuscles, exercise.secondaryMuscles);
      expect(parsed.bodyRegions, exercise.bodyRegions);
      expect(parsed.difficulty, exercise.difficulty);
      expect(parsed.intensity, exercise.intensity);
      expect(parsed.isLottie, isTrue);
      expect(parsed.equipments, [Equipment.yogaMat]);
    });

    test('fromJson parses raw JSON with semicolons and commas', () {
      final json = {
        'exercise_id': 'ex_2',
        'name': 'Squat',
        'type': 'bodyweight',
        'primary_muscles': 'Quadriceps; Glutes',
        'secondary_muscles': 'Hamstrings, Calves',
        'body_region': 'lower_body; core',
        'movement_pattern': 'Squat',
        'difficulty': 'intermediate',
        'intensity': 'high',
        'goal_tags': 'Legs; Endurance',
        'overview': 'Basic bodyweight squat',
        'benefits': 'Leg strength',
        'contraindications': 'Knee pain',
        'instructions': 'Lower your hips back and down.',
        'is_lottie': false,
        'equipments': 'bench, dumbbells',
        'animation_link': 'https://example.com/squat.json',
      };

      final parsed = Exercise.fromJson(json);

      expect(parsed.exerciseId, 'ex_2');
      expect(parsed.name, 'Squat');
      expect(parsed.primaryMuscles, ['Quadriceps', 'Glutes']);
      expect(parsed.secondaryMuscles, ['Hamstrings', 'Calves']);
      expect(parsed.bodyRegions, [BodyRegion.lowerBody, BodyRegion.core]);
      expect(parsed.difficulty, Difficulty.intermediate);
      expect(parsed.intensity, Intensity.high);
      expect(parsed.isLottie, isFalse);
      expect(parsed.equipments, [Equipment.bench, Equipment.dumbbells]);
    });
  });
}
