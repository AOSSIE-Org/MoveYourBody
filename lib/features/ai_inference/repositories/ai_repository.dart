import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/onnx_service.dart';
import '../services/tokenizer_service.dart';

final aiModelRepositoryProvider = Provider((ref) => AiModelRepository(ref));

class AiModelRepository {
  final Ref _ref;
  AiModelRepository(this._ref);

  bool get isReady =>
      _ref.read(tokenizerServiceProvider).isInitialized &&
      _ref.read(onnxServiceProvider).isInitialized;

  /// Safe to call more than once; the tokenizer and model are only loaded
  /// the first time.
  Future<void> initModel() async {
    final onnxService = _ref.read(onnxServiceProvider);
    final tokenizerService = _ref.read(tokenizerServiceProvider);

    await Future.wait([tokenizerService.init(), onnxService.init()]);
  }

  /// Returns the embedding as raw Float32 bytes, or `null` when the text is
  /// empty or the pipeline could not produce an embedding.
  Future<Uint8List?> generateEmbedding(String text) async {
    if (text.trim().isEmpty) {
      debugPrint(
        "AI Repo: Input text is empty. Skipping embedding generation.",
      );
      return null;
    }
    if (!isReady) {
      try {
        await initModel();
      } catch (e) {
        debugPrint("AI Repo: Model unavailable, skipping embedding: $e");
        return null;
      }
    }

    final onnxService = _ref.read(onnxServiceProvider);
    final tokenizerService = _ref.read(tokenizerServiceProvider);
    final tokens = tokenizerService.encode(text);
    if (tokens == null) return null;
    final List<double> embeddingVector = await onnxService.runInference(
      tokens['input_ids']!,
      tokens['attention_mask']!,
      tokens['token_type_ids']!,
    );
    if (embeddingVector.isEmpty) return null;
    final Float32List float32vector = embeddingVector is Float32List
        ? embeddingVector
        : Float32List.fromList(embeddingVector);
    return float32vector.buffer.asUint8List(
      float32vector.offsetInBytes,
      float32vector.lengthInBytes,
    );
  }
}
