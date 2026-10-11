import 'dart:typed_data';

import 'package:move_your_body/core/database/tables/tags_table.dart';

enum TagType { goal, injury }

class Tag {
  final int? id;
  final String tagName;
  final TagType tagType;
  final Uint8List? embedding;

  const Tag({
    this.id,
    required this.tagName,
    required this.tagType,
    this.embedding,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) TagsTable.id: id,
      TagsTable.tagName: tagName,
      TagsTable.tagType: tagType.name,
      TagsTable.embedding: embedding,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map[TagsTable.id] as int?,
      tagName: map[TagsTable.tagName] as String? ?? '',
      tagType: TagType.values.firstWhere(
        (e) => e.name == map[TagsTable.tagType],
      ),
      embedding: map[TagsTable.embedding] as Uint8List?,
    );
  }

  Tag copyWith({
    int? id,
    String? tagName,
    TagType? tagType,
    Uint8List? embedding,
  }) {
    return Tag(
      id: id ?? this.id,
      tagName: tagName ?? this.tagName,
      tagType: tagType ?? this.tagType,
      embedding: embedding ?? this.embedding,
    );
  }
}
