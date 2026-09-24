class QuickPlanTable {
  static const tableName = 'quick_plans';
  static const id = 'id';
  static const name = 'name';
  static const description = 'description';
  static const imagePath = 'image_path';
}

class QuickPlanExercisesTable {
  static const tableName = 'quick_plan_exercises';
  static const id = 'id';
  static const planId = 'plan_id';
  static const exerciseId = 'exercise_id';
  static const orderIndex = 'order_index';
}
