import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';

class PastSessionDetailsData {
  final Session session;
  final Map<String, Exercise> exerciseDetails;

  PastSessionDetailsData({
    required this.session,
    required this.exerciseDetails,
  });
}

final pastSessionDetailsProvider =
    FutureProvider.family<PastSessionDetailsData, int>((ref, sessionId) async {
      final sessionRepository = ref.read(sessionRepositoryProvider);
      final exerciseRepository = ref.read(exerciseRepositoryProvider);

      final session = await sessionRepository.getSessionById(sessionId);
      if (session == null) {
        throw Exception('Session not found.');
      }

      final exerciseIds = session.exercises.map((e) => e.exerciseId).toList();
      final exercises = await exerciseRepository.getExercisesByIds(exerciseIds);

      final exerciseMap = {for (var e in exercises) e.exerciseId: e};

      return PastSessionDetailsData(
        session: session,
        exerciseDetails: exerciseMap,
      );
    });
