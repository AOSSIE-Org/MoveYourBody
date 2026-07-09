import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/ai_inference/services/cosine_similairty.dart';

void main() {
  group('SimilarityUtils - calculateCosineSimilarity', () {
    test('Identical vectors should return 1.0', () {
      final v1 = [1.0, 2.0, 3.0];
      final v2 = [1.0, 2.0, 3.0];
      final similarity = SimilarityUtils.calculateCosineSimilarity(v1, v2);
      expect(similarity, closeTo(1.0, 1e-9));
    });

    test('Orthogonal vectors should return 0.0', () {
      final v1 = [1.0, 0.0];
      final v2 = [0.0, 1.0];
      final similarity = SimilarityUtils.calculateCosineSimilarity(v1, v2);
      expect(similarity, closeTo(0.0, 1e-9));
    });

    test('Opposite vectors should return -1.0', () {
      final v1 = [1.0, -1.0];
      final v2 = [-1.0, 1.0];
      final similarity = SimilarityUtils.calculateCosineSimilarity(v1, v2);
      expect(similarity, closeTo(-1.0, 1e-9));
    });

    test('Mismatched vector lengths should return 0.0', () {
      final v1 = [1.0, 2.0];
      final v2 = [1.0, 2.0, 3.0];
      final similarity = SimilarityUtils.calculateCosineSimilarity(v1, v2);
      expect(similarity, equals(0.0));
    });

    test('Empty vectors should return 0.0', () {
      final v1 = <double>[];
      final v2 = <double>[];
      final similarity = SimilarityUtils.calculateCosineSimilarity(v1, v2);
      expect(similarity, equals(0.0));
    });

    test('Zero vectors should return 0.0 (handles division by zero)', () {
      final v1 = [0.0, 0.0];
      final v2 = [1.0, 2.0];
      final similarity = SimilarityUtils.calculateCosineSimilarity(v1, v2);
      expect(similarity, equals(0.0));
    });

    test('Standard arbitrary similarity calculation is correct', () {
      final v1 = [3.0, 4.0];
      final v2 = [4.0, 3.0];
      final similarity = SimilarityUtils.calculateCosineSimilarity(v1, v2);
      expect(similarity, closeTo(0.96, 1e-9));
    });
  });
}
