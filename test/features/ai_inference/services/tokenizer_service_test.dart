import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/ai_inference/services/tokenizer_service.dart';

void main() {
  group('TokenizerService Tests', () {
    late TokenizerService tokenizerService;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      tokenizerService = TokenizerService();
    });

    test('encode should return null if not initialized', () {
      final result = tokenizerService.encode('Hello Vaibhav');

      expect(result, isNull);
    });

    test('init should successfully load vocab and encode text', () async {
      await tokenizerService.init();

      final result = tokenizerService.encode('Test John');
      expect(result, isNotNull);
      expect(result!['input_ids'], isNotNull);
      expect(result['attention_mask'], isNotNull);
    });
  });
}
