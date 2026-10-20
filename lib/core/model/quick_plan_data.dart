import 'package:move_your_body/core/database/tables/quick_plan_table.dart';

class QuickPlan {
  final int id;
  final String name;
  final String description;
  final String? imagePath;

  const QuickPlan({
    required this.id,
    required this.name,
    required this.description,
    this.imagePath,
  });

  factory QuickPlan.fromMap(Map<String, dynamic> map) {
    return QuickPlan(
      id: map[QuickPlanTable.id] as int,
      name: map[QuickPlanTable.name] as String,
      description: map[QuickPlanTable.description] as String,
      imagePath: map[QuickPlanTable.imagePath] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      QuickPlanTable.id: id,
      QuickPlanTable.name: name,
      QuickPlanTable.description: description,
      QuickPlanTable.imagePath: imagePath,
    };
  }

  QuickPlan copyWith({
    int? id,
    String? name,
    String? description,
    String? imagePath,
  }) {
    return QuickPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
