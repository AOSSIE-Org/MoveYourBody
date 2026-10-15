import 'package:flutter/foundation.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'embedding_pooling.dart';

final onnxServiceProvider = Provider((ref) {
  final service = OnnxService();
  ref.onDispose(service.close);
  return service;
});

class OnnxService {
  static const _modelAsset = 'assets/models/model_quantized.onnx';

  OrtSession? _session;
  Future<void>? _initFuture;
  bool _closed = false;
  final _ort = OnnxRuntime();

  bool get isInitialized => _session != null;

  /// Loads the model once. Concurrent or repeated calls share the same
  /// session instead of creating a new one each time. A failed load can be
  /// retried by calling [init] again.
  Future<void> init() {
    if (_session != null) return Future.value();
    if (_closed) {
      return Future.error(StateError("OnnxService has been closed"));
    }
    return _initFuture ??= _loadSession().whenComplete(() {
      if (_session == null) _initFuture = null;
    });
  }

  Future<void> _loadSession() async {
    try {
      debugPrint("AIService: Initializing ONNX Runtime...");
      final stopwatch = Stopwatch()..start();
      final session = await _ort.createSessionFromAsset(_modelAsset);
      if (_closed) {
        // close() ran while the model was loading; don't keep the session.
        await session.close();
        return;
      }
      _session = session;
      debugPrint(
        "AIService: Model loaded successfully in ${stopwatch.elapsedMilliseconds}ms.",
      );
    } catch (e) {
      debugPrint("AIService: Initialization Error: $e");
      rethrow;
    }
  }

  /// Runs the model and returns an L2-normalized, mean-pooled sentence
  /// embedding. Returns an empty list if the session is unavailable or
  /// inference fails.
  Future<List<double>> runInference(
    Int64List inputIds,
    Int64List attentionMask,
    Int64List tokenTypeIds,
  ) async {
    final session = _session;
    if (session == null) {
      debugPrint("AIService: Inference skipped, session not initialized.");
      return [];
    }
    if (inputIds.isEmpty ||
        inputIds.length != attentionMask.length ||
        inputIds.length != tokenTypeIds.length) {
      debugPrint("AIService: Inference skipped, invalid input lengths.");
      return [];
    }

    final seqLen = inputIds.length;
    final inputs = <String, OrtValue>{};
    Map<String, OrtValue> outputs = const {};

    try {
      inputs['input_ids'] = await OrtValue.fromList(inputIds, [1, seqLen]);
      inputs['attention_mask'] = await OrtValue.fromList(attentionMask, [
        1,
        seqLen,
      ]);
      inputs['token_type_ids'] = await OrtValue.fromList(tokenTypeIds, [
        1,
        seqLen,
      ]);

      outputs = await session.run(inputs);
      if (outputs.isEmpty) return [];

      final output = outputs['last_hidden_state'] ?? outputs.values.first;
      final shape = output.shape;
      final flat = (await output.asFlattenedList()).cast<num>();

      // [1, seqLen, hidden]: token embeddings that still need pooling.
      if (shape.length == 3) {
        return EmbeddingPooling.meanPool(flat, attentionMask, shape[2]);
      }
      // [1, hidden]: model already returns a pooled sentence embedding.
      if (shape.length == 2) {
        return EmbeddingPooling.l2Normalize(flat);
      }

      debugPrint("AIService: Unexpected output shape $shape");
      return [];
    } catch (e) {
      debugPrint("AIService: Inference Error: $e");
      return [];
    } finally {
      // OrtValues hold native memory; release them on every run so repeated
      // inference across sessions does not leak.
      for (final value in [...inputs.values, ...outputs.values]) {
        try {
          await value.dispose();
        } catch (_) {}
      }
    }
  }

  Future<void> close() async {
    _closed = true;
    final session = _session;
    _session = null;
    _initFuture = null;
    if (session == null) return;
    try {
      await session.close();
    } catch (e) {
      debugPrint("AIService: Error closing session: $e");
    }
  }
}
