import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../database/tables/exercise_table.dart';

enum ExerciseType {
  bodyweight,
  stabilityBall,
  cardio,
  dumbbell,
  yoga,
  strength,
}

enum BodyRegion {
  lowerBody,
  core,
  fullBody,
  upperBody,
  cardioAndEndurance,
  mobilityAndFlexibility,
}

enum Difficulty { beginner, intermediate, advanced }

enum Intensity { low, moderate, high }

enum Equipment { stabilityBall, bench, dumbbells, yogaMat, jumpRope }

class Exercise {
  final String exerciseId;
  final String name;

  final ExerciseType type;

  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;

  final List<BodyRegion> bodyRegions;

  final String movementPattern;

  final Difficulty difficulty;

  final Intensity intensity;

  final List<String> goalTags;

  final int estimatedTime;

  final String overview;
  final String benefits;

  final List<String> contraindications;

  final String instructions;

  final bool isLottie;

  final List<Equipment> equipments;

  final String animationLink;

  const Exercise({
    required this.exerciseId,
    required this.name,
    required this.type,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.bodyRegions,
    required this.movementPattern,
    required this.difficulty,
    required this.intensity,
    required this.goalTags,
    required this.estimatedTime,
    required this.overview,
    required this.benefits,
    required this.contraindications,
    required this.instructions,
    required this.isLottie,
    required this.equipments,
    required this.animationLink,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    debugPrint(
      'Parsing: ${json['exercise_id']} '
      'type=${json['type']} '
      'difficulty=${json['difficulty']} '
      'intensity=${json['intensity']}',
    );
    return Exercise(
      exerciseId: json['exercise_id'],
      name: json['name'],

      type: ExerciseType.values.firstWhere((e) => e.name == json['type']),

      primaryMuscles: _splitByComma(json['primary_muscles']),

      secondaryMuscles: _splitByComma(json['secondary_muscles']),

      bodyRegions: _parseBodyRegions(json['body_region']),

      movementPattern: json['movement_pattern'] ?? '',

      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      ),

      intensity: Intensity.values.firstWhere(
        (e) => e.name == json['intensity'],
      ),

      goalTags: _splitByComma(json['goal_tags']),

      estimatedTime: 30,

      overview: json['overview'] ?? '',

      benefits: json['benefits'] ?? '',

      contraindications: _splitByComma(json['contraindications']),

      instructions: json['instructions'] ?? '',

      isLottie: json['is_lottie'] ?? false,

      equipments: _parseEquipments(json['equipments']),

      animationLink: json['animation_link'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ExerciseTable.exerciseId: exerciseId,
      ExerciseTable.name: name,
      ExerciseTable.type: type.name,

      ExerciseTable.primaryMuscles: jsonEncode(primaryMuscles),

      ExerciseTable.secondaryMuscles: jsonEncode(secondaryMuscles),

      ExerciseTable.bodyRegions: jsonEncode(
        bodyRegions.map((e) => e.name).toList(),
      ),

      ExerciseTable.movementPattern: movementPattern,

      ExerciseTable.difficulty: difficulty.name,

      ExerciseTable.intensity: intensity.name,

      ExerciseTable.goalTags: jsonEncode(goalTags),

      ExerciseTable.estimatedTime: estimatedTime,

      ExerciseTable.overview: overview,

      ExerciseTable.benefits: benefits,

      ExerciseTable.contraindications: jsonEncode(contraindications),

      ExerciseTable.instructions: instructions,

      ExerciseTable.isLottie: isLottie ? 1 : 0,

      ExerciseTable.equipments: jsonEncode(
        equipments.map((e) => e.name).toList(),
      ),

      ExerciseTable.animationLink: animationLink,
    };
  }

  static List<String> _splitByComma(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return [];
    }
    return value
        .toString()
        .split(RegExp(r'[;,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static List<BodyRegion> _parseBodyRegions(String value) {
    if (value.isEmpty || value == "") return [];

    return value.split(';').map((e) {
      switch (e.trim()) {
        case 'lower_body':
          return BodyRegion.lowerBody;
        case 'core':
          return BodyRegion.core;
        case 'full_body':
          return BodyRegion.fullBody;
        case 'upper_body':
          return BodyRegion.upperBody;
        case 'cardio_and_endurance':
          return BodyRegion.cardioAndEndurance;
        default:
          return BodyRegion.mobilityAndFlexibility;
      }
    }).toList();
  }

  static List<Equipment> _parseEquipments(String value) {
    if (value.trim().isEmpty) return [];

    return value.split(',').map((e) {
      switch (e.trim()) {
        case 'bench':
          return Equipment.bench;
        case 'dumbbells':
          return Equipment.dumbbells;
        case 'yoga_mat':
          return Equipment.yogaMat;
        case 'jump_rope':
          return Equipment.jumpRope;
        default:
          return Equipment.stabilityBall;
      }
    }).toList();
  }
}
