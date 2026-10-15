import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/ai_inference/services/cosine_similairty.dart';
import 'package:move_your_body/features/ai_inference/services/embedding_pooling.dart';

double _norm(List<double> v) => sqrt(v.fold(0.0, (s, x) => s + x * x));

void main() {
  group('EmbeddingPooling.meanPool', () {
    test('averages only unmasked tokens and normalizes', () {
      // 3 tokens, hidden size 2; last token is padding.
      final tokens = [1.0, 3.0, 3.0, 1.0, 100.0, 100.0];
      final mask = [1, 1, 0];

      final pooled = EmbeddingPooling.meanPool(tokens, mask, 2);

      expect(pooled.length, 2);
      expect(pooled[0], closeTo(sqrt(0.5), 1e-6));
      expect(pooled[1], closeTo(sqrt(0.5), 1e-6));
      expect(_norm(pooled), closeTo(1.0, 1e-6));
    });

    test('returns empty on shape mismatch', () {
      expect(EmbeddingPooling.meanPool([1.0, 2.0, 3.0], [1, 1], 2), isEmpty);
    });

    test('returns empty when every token is masked', () {
      expect(EmbeddingPooling.meanPool([1.0, 2.0], [0], 2), isEmpty);
    });
  });

  group('EmbeddingPooling.l2Normalize', () {
    test('produces a unit vector', () {
      final out = EmbeddingPooling.l2Normalize([3.0, 4.0]);
      expect(out[0], closeTo(0.6, 1e-6));
      expect(out[1], closeTo(0.8, 1e-6));
    });

    test('leaves a zero vector as zeros', () {
      expect(EmbeddingPooling.l2Normalize([0.0, 0.0]), [0.0, 0.0]);
    });
  });

  test('cosine similarity of normalized vectors equals dot product', () {
    final a = EmbeddingPooling.l2Normalize([1.0, 2.0, 3.0]);
    final b = EmbeddingPooling.l2Normalize([3.0, 2.0, 1.0]);
    final dot = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
    expect(SimilarityUtils.calculateCosineSimilarity(a, b), closeTo(dot, 1e-6));
  });
}
