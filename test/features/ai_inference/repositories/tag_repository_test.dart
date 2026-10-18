import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/features/ai_inference/repositories/tag_repository.dart';
import 'package:move_your_body/core/model/tag_data.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TagRepository Tests', () {
    late TagRepository repository;

    setUp(() {
      repository = TagRepository();
    });

    test(
      'findTopMatches returns empty list when userEmbedding is null or empty',
      () async {
        final matchesForNull = await repository.findTopMatches(
          type: TagType.goal,
          userEmbedding: null,
        );

        expect(matchesForNull, isEmpty);

        final matchesForEmpty = await repository.findTopMatches(
          type: TagType.goal,
          userEmbedding: Uint8List(0),
        );

        expect(matchesForEmpty, isEmpty);
      },
    );

    test('_bytesToFloatVector edge cases via findTopMatches', () async {
      final invalidEmbedding = Uint8List.fromList([1, 2, 3]);

      final matches = await repository.findTopMatches(
        type: TagType.goal,
        userEmbedding: invalidEmbedding,
      );
      expect(matches, isEmpty);
    });
    test('updateResolvedTags should execute without crashing', () async {
      expect(
        () async => await repository.updateResolvedTags(
          goals: ['weight_loss', 'flexibility'],
          injuries: ['back_pain'],
        ),
        returnsNormally,
      );
    });
  });
}
