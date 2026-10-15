import 'dart:math';
import 'dart:typed_data';

/// Pooling helpers for turning raw transformer output into a sentence
/// embedding, matching the sentence-transformers all-MiniLM-L6-v2 recipe
/// (mean pooling over real tokens followed by L2 normalization).
class EmbeddingPooling {
  /// Mean-pools a flattened `[1, seqLen, hiddenSize]` token embedding tensor,
  /// ignoring positions where [attentionMask] is `0`, then L2-normalizes it.
  ///
  /// Returns an empty list when the input shape is inconsistent.
  static Float32List meanPool(
    List<num> tokenEmbeddings,
    List<int> attentionMask,
    int hiddenSize,
  ) {
    final seqLen = attentionMask.length;
    if (hiddenSize <= 0 ||
        seqLen == 0 ||
        tokenEmbeddings.length != seqLen * hiddenSize) {
      return Float32List(0);
    }

    final pooled = Float64List(hiddenSize);
    int realTokens = 0;

    for (int t = 0; t < seqLen; t++) {
      if (attentionMask[t] == 0) continue;
      realTokens++;
      final offset = t * hiddenSize;
      for (int h = 0; h < hiddenSize; h++) {
        pooled[h] += tokenEmbeddings[offset + h];
      }
    }

    if (realTokens == 0) return Float32List(0);

    for (int h = 0; h < hiddenSize; h++) {
      pooled[h] /= realTokens;
    }
    return l2Normalize(pooled);
  }

  /// Returns a unit-length copy of [vector]. A zero vector is returned as-is.
  static Float32List l2Normalize(List<num> vector) {
    double sumSquares = 0.0;
    for (final v in vector) {
      sumSquares += v * v;
    }
    final out = Float32List(vector.length);
    if (sumSquares == 0.0) return out;

    final norm = sqrt(sumSquares);
    for (int i = 0; i < vector.length; i++) {
      out[i] = vector[i] / norm;
    }
    return out;
  }
}
