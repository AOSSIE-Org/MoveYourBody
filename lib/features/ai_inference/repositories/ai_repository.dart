import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/onnx_service.dart';
import '../services/tokenizer_service.dart';

final aiModelRepositoryProvider = Provider((ref) => AiModelRepository(ref));

class AiModelRepository {
  final Ref _ref;
  AiModelRepository(this._ref);
  Future<void> initModel() async {
    final onnxService = _ref.read(onnxServiceProvider);
    final tokenizerService = _ref.read(tokenizerServiceProvider);

    await tokenizerService.init();
    await onnxService.init();
  }

  Future<Uint8List?> generateEmbedding(String text) async {
    if (text.trim().isEmpty) {
      print("🧠 AI Repo: Input text is empty. Skipping embedding generation.");
      return null;
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
    final Float32List float32vector = Float32List.fromList(embeddingVector);
    return float32vector.buffer.asUint8List();
  }
}
