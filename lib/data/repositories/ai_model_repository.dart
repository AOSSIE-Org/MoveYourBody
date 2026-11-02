import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:move_your_body/data/services/onnx_service.dart';
import 'package:move_your_body/data/services/tokenizer_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/ai_model_repository.g.dart';

@Riverpod(keepAlive: true)
AiModelRepository aiModelRepository(Ref ref) {
  final onnxService = ref.read(onnxServiceProvider);
  final tokenizerService = ref.read(tokenizerServiceProvider);
  return AiModelRepository(onnxService, tokenizerService);
}

class AiModelRepository {
  final OnnxService _onnxService;
  final TokenizerService _tokenizerService;

  AiModelRepository(this._onnxService, this._tokenizerService);

  Future<void> initModel() async {
    await _tokenizerService.init();
    await _onnxService.init();
  }

  Future<Uint8List?> generateEmbedding(String text) async {
    if (text.trim().isEmpty) {
      debugPrint(
        "🧠 AI Repo: Input text is empty. Skipping embedding generation.",
      );
      return null;
    }
    final tokens = _tokenizerService.encode(text);
    if (tokens == null) return null;
    final List<double> embeddingVector = await _onnxService.runInference(
      tokens['input_ids']!,
      tokens['attention_mask']!,
      tokens['token_type_ids']!,
    );
    if (embeddingVector.isEmpty) return null;
    final Float32List float32vector = Float32List.fromList(embeddingVector);
    return float32vector.buffer.asUint8List();
  }
}
