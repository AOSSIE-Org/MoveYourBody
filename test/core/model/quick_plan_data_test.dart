import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/domain/models/quick_plan_data.dart';

void main() {
  group('QuickPlan Model Tests', () {
    const plan = QuickPlan(
      id: 1,
      name: 'Morning Energy',
      description: 'Quick 10-minute energizing session',
      imagePath: 'assets/images/morning.png',
      isCustom: true,
    );

    test('toMap serializes QuickPlan correctly', () {
      final map = plan.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Morning Energy');
      expect(map['description'], 'Quick 10-minute energizing session');
      expect(map['image_path'], 'assets/images/morning.png');
      expect(map['is_custom'], 1);
    });

    test('fromMap deserializes map correctly', () {
      final map = {
        'id': 2,
        'name': 'Core Blast',
        'description': 'Target abdominal muscles',
        'image_path': null,
        'is_custom': 0,
      };

      final parsed = QuickPlan.fromMap(map);

      expect(parsed.id, 2);
      expect(parsed.name, 'Core Blast');
      expect(parsed.description, 'Target abdominal muscles');
      expect(parsed.imagePath, isNull);
      expect(parsed.isCustom, isFalse);
    });

    test('copyWith updates properties properly', () {
      final updated = plan.copyWith(name: 'Evening Stretch', isCustom: false);

      expect(updated.id, plan.id);
      expect(updated.name, 'Evening Stretch');
      expect(updated.description, plan.description);
      expect(updated.isCustom, isFalse);
    });
  });
}
