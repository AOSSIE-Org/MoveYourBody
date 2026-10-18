import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/ai_repository.dart';
import '../repositories/tag_setup_repository.dart';
import '../services/cosine_similairty.dart';

part 'generated/ai_inference_view_model.g.dart';

class AiState {
  final bool isReady;
  final bool isProcessing;
  final String? bestMatchResult;

  const AiState({
    this.isReady = false,
    this.isProcessing = false,
    this.bestMatchResult,
  });

  AiState copyWith({
    bool? isReady,
    bool? isProcessing,
    String? bestMatchResult,
  }) {
    return AiState(
      isReady: isReady ?? this.isReady,
      isProcessing: isProcessing ?? this.isProcessing,
      bestMatchResult: bestMatchResult ?? this.bestMatchResult,
    );
  }
}

@Riverpod(keepAlive: true)
class AiInferenceViewModel extends _$AiInferenceViewModel {
  @override
  AiState build() {
    return const AiState();
  }

  Future<void> initializeAiAndTags() async {
    try {
      debugPrint("AI Lifecycle: Starting initialization pipeline...");
      final aiModelRepo = ref.read(aiModelRepositoryProvider);
      final tagSetupRepo = ref.read(tagSetupRepositoryProvider);
      await aiModelRepo.initModel();
      await tagSetupRepo.processAndSeedTags();

      if (!ref.mounted) return;

      state = state.copyWith(isReady: true);
      debugPrint("AI Lifecycle: Pipeline is READY and Cached");
    } catch (e) {
      debugPrint("AI Lifecycle: Initialization Critical Error: $e");
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
      debugPrint("AI Engine: Engine is not ready yet!");
      return;
    }
    try {
      state = state.copyWith(isProcessing: true);

      final aiModelRepo = ref.read(aiModelRepositoryProvider);
      final embeddingBytes = await aiModelRepo.generateEmbedding(query);

      if (embeddingBytes != null) {
        final float32Buffer = embeddingBytes.buffer.asFloat32List();
        final List<double> userEmbedding = float32Buffer.toList();

        if (!ref.mounted) return;

        String bestMatch = "No Match Found";
        double highestScore = -1.0;

        for (var entry in targetEmbeddingsDb.entries) {
          double score = SimilarityUtils.calculateCosineSimilarity(
            userEmbedding,
            entry.value,
          );
          if (score > highestScore) {
            highestScore = score;
            bestMatch = entry.key;
          }
        }

        state = state.copyWith(isProcessing: false, bestMatchResult: bestMatch);
      } else {
        if (!ref.mounted) return;
        state = state.copyWith(
          isProcessing: false,
          bestMatchResult: "Error parsing query",
        );
      }
    } catch (e) {
      debugPrint("AI Engine: Error occurred while processing user query: $e");
      if (!ref.mounted) return;
      state = state.copyWith(
        isProcessing: false,
        bestMatchResult: "Error occurred while processing query",
      );
    }
  }
}
