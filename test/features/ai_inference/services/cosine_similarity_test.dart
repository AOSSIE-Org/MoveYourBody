import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/ai_inference/services/cosine_similairty.dart';

void main() {
  group('Cosine Similarity Utils Tests', () {
    test('calculateCosineSimilarity should return 0.0 for empty vectors', () {
      final result = SimilarityUtils.calculateCosineSimilarity([], []);
      expect(result, 0.0);
    });

    test(
      'calculateCosineSimilarity should return 0.0 for vectors of different lengths',
      () {
        final result = SimilarityUtils.calculateCosineSimilarity(
          [1.0, 2.0],
          [1.0],
        );
        expect(result, 0.0);
      },
    );

    test(
      'calculateCosineSimilarity should correctly calculate identical vectors',
      () {
        final result = SimilarityUtils.calculateCosineSimilarity(
          [1.0, 2.0, 3.0],
          [1.0, 2.0, 3.0],
        );
        expect(result, closeTo(1.0, 0.0001));
      },
    );

    test(
      'calculateCosineSimilarity should correctly calculate opposite vectors',
      () {
        final result = SimilarityUtils.calculateCosineSimilarity(
          [1.0, 2.0, 3.0],
          [-1.0, -2.0, -3.0],
        );
        expect(result, closeTo(-1.0, 0.0001));
      },
    );

    test(
      'calculateCosineSimilarity should correctly calculate orthogonal vectors',
      () {
        final result = SimilarityUtils.calculateCosineSimilarity(
          [1.0, 0.0],
          [0.0, 1.0],
        );
        expect(result, 0.0);
      },
    );

    test(
      'calculateCosineSimilarity should return 0.0 if one vector is all zeros (magnitude is 0)',
      () {
        final result = SimilarityUtils.calculateCosineSimilarity(
          [1.0, 2.0],
          [0.0, 0.0],
        );
        expect(result, 0.0);
      },
    );
  });
}
