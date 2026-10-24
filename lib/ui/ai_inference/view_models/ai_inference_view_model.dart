import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/data/repositories/ai_model_repository.dart';
import 'package:move_your_body/domain/models/ai_state.dart';
import 'package:move_your_body/utils/cosine_similairty.dart';

part 'generated/ai_inference_view_model.g.dart';

@Riverpod(keepAlive: true)
class AiInferenceViewModel extends _$AiInferenceViewModel {
  @override
  AiState build() => const AiState();

  Future<void> initializeAiAndTags() async {
    try {
      debugPrint("AI Lifecycle: Starting initialization pipeline...");
      final aiModelRepo = ref.read(aiModelRepositoryProvider);
      await aiModelRepo.initModel();

      if (!ref.mounted) return;

      state = state.copyWith(isReady: true);
      debugPrint("AI Lifecycle: Pipeline is READY and Cached");
    } catch (e) {
      debugPrint("AI Lifecycle: Initialization Critical Error: $e");
      rethrow;
    }
  }

  void setEngineReady() {
    state = state.copyWith(isReady: true);
    debugPrint("🤖 AI Inference State: Explicitly set to READY");
  }

  Future<void> processUserQuery({
    required String query,
    required Map<String, List<double>> targetEmbeddingsDb,
  }) async {
    if (!state.isReady) {
      throw StateError("AI Engine is not ready yet!");
    }
    state = state.copyWith(isProcessing: true);
    try {
      final aiModelRepo = ref.read(aiModelRepositoryProvider);
      final embeddingBytes = await aiModelRepo.generateEmbedding(query);

      if (embeddingBytes == null) {
        throw Exception("Failed to generate embedding for query: $query");
      }

      final float32Buffer = embeddingBytes.buffer.asFloat32List();
      final List<double> userEmbedding = float32Buffer.toList();

      if (!ref.mounted) return;

      String bestMatch = "No Match Found";
      double highestScore = -1.0;

      for (var entry in targetEmbeddingsDb.entries) {
        double score = SimilarityHelper.calculateCosineSimilarity(
          userEmbedding,
          entry.value,
        );
        if (score > highestScore) {
          highestScore = score;
          bestMatch = entry.key;
        }
      }

      state = state.copyWith(isProcessing: false, bestMatchResult: bestMatch);
    } catch (e) {
      debugPrint("AI Engine: Error occurred while processing user query: $e");
      if (ref.mounted) {
        state = state.copyWith(isProcessing: false);
      }
      rethrow;
    }
  }
}
