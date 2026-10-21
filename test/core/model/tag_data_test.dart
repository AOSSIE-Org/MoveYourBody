import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/core/model/tag_data.dart';

void main() {
  group('Tag Model Tests', () {
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    final tag = Tag(
      id: 1,
      tagName: 'Fat Loss',
      tagType: TagType.goal,
      embedding: bytes,
    );

    test('toMap serializes Tag correctly', () {
      final map = tag.toMap();

      expect(map['id'], 1);
      expect(map['tag_name'], 'Fat Loss');
      expect(map['tag_type'], 'goal');
      expect(map['embedding'], bytes);
    });

    test('fromMap deserializes Tag correctly', () {
      final map = {
        'id': 2,
        'tag_name': 'Lower Back Pain',
        'tag_type': 'injury',
        'embedding': bytes,
      };

      final parsed = Tag.fromMap(map);

      expect(parsed.id, 2);
      expect(parsed.tagName, 'Lower Back Pain');
      expect(parsed.tagType, TagType.injury);
      expect(parsed.embedding, bytes);
    });

    test('copyWith updates properties properly', () {
      final updated = tag.copyWith(
        tagName: 'Cardio Boost',
        tagType: TagType.injury,
      );

      expect(updated.id, tag.id);
      expect(updated.tagName, 'Cardio Boost');
      expect(updated.tagType, TagType.injury);
      expect(updated.embedding, tag.embedding);
    });
  });
}