import 'package:flutter/foundation.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onnxServiceProvider = Provider((ref) => OnnxService());

class OnnxService {
  OrtSession? _session;
  final _ort = OnnxRuntime();

  Future<void> init() async {
    try {
      debugPrint("AIService: Initializing ONNX Runtime...");
      _session = await _ort.createSessionFromAsset(
        'assets/models/model_quantized.onnx',
      );
      debugPrint("AIService: Model loaded successfully.");
    } catch (e) {
      debugPrint("AIService: Initialization Error: $e");
      rethrow;
    }
  }

  Future<List<double>> runInference(
    Int64List inputIds,
    Int64List attentionMask,
    Int64List tokenTypeIds,
  ) async {
    try {
      if (_session == null) throw Exception("Session not initialized");

      final inputs = {
        'input_ids': await OrtValue.fromList(inputIds, [1, inputIds.length]),
        'attention_mask': await OrtValue.fromList(attentionMask, [
          1,
          attentionMask.length,
        ]),
        'token_type_ids': await OrtValue.fromList(tokenTypeIds, [
          1,
          tokenTypeIds.length,
        ]),
      };

      final outputs = await _session!.run(inputs);

      final outputValue = outputs.values.first;
      final List<dynamic> rawList = await outputValue.asList();
      final List<double> clsEmbedding = (rawList[0][0] as List).cast<double>();

      return clsEmbedding;
    } catch (e) {
      debugPrint("AIService: Inference Error: $e");
      return [];
    }
  }
}
