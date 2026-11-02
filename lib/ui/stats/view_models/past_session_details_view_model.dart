import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/domain/models/session_data.dart';
import 'package:move_your_body/data/repositories/exercise_repository.dart';
import 'package:move_your_body/data/repositories/session_repository.dart';

part 'generated/past_session_details_view_model.g.dart';

class PastSessionDetailsData {
  final Session session;
  final Map<String, Exercise> exerciseDetails;

  PastSessionDetailsData({
    required this.session,
    required this.exerciseDetails,
  });
}

@riverpod
Future<PastSessionDetailsData> pastSessionDetails(
  Ref ref,
  int sessionId,
) async {
  final sessionRepository = ref.read(sessionRepositoryProvider);
  final exerciseRepository = ref.read(exerciseRepositoryProvider.notifier);

  final session = await sessionRepository.getSessionById(sessionId);
  if (session == null) {
    throw Exception('Session not found.');
  }

  final exerciseIds = session.exercises.map((e) => e.exerciseId).toList();
  final exercises = await exerciseRepository.getExercisesByIds(exerciseIds);

  final exerciseMap = {for (var e in exercises) e.exerciseId: e};

  return PastSessionDetailsData(session: session, exerciseDetails: exerciseMap);
}
