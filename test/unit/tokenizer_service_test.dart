import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/ai_inference/services/tokenizer_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TokenizerService Tests', () {
    late TokenizerService tokenizerService;

    setUp(() async {
      tokenizerService = TokenizerService();
      await tokenizerService.init();
    });

    test('Tokenizer initializes and loads vocabulary successfully', () {
      final result = tokenizerService.encode('hello');
      expect(result, isNotNull);
      expect(result!['input_ids'], isNotEmpty);
      expect(result['attention_mask'], isNotEmpty);
      expect(result['token_type_ids'], isNotEmpty);
    });

    test('Encoding standard text yields valid input structure and active attention mask', () {
      final result = tokenizerService.encode('back pain');
      expect(result, isNotNull);

      final inputIds = result!['input_ids']!;
      final attentionMask = result['attention_mask']!;
      final tokenTypeIds = result['token_type_ids']!;

      final nonPaddedLength = attentionMask.where((val) => val == 1).length;

      expect(inputIds.length, greaterThanOrEqualTo(nonPaddedLength));
      expect(attentionMask.take(nonPaddedLength), everyElement(equals(1)));
      expect(tokenTypeIds.take(nonPaddedLength), everyElement(equals(0)));
    });

    test('Encoding empty query yields minimum valid structure', () {
      final result = tokenizerService.encode('');
      expect(result, isNotNull);
      
      final attentionMask = result!['attention_mask']!;
      final nonPaddedLength = attentionMask.where((val) => val == 1).length;
      
      expect(nonPaddedLength, equals(2));
    });

    test('Encoding longer phrases yields more active tokens than shorter phrases', () {
      final shortResult = tokenizerService.encode('back');
      final longResult = tokenizerService.encode('back pain and muscle stiffness');

      final shortActiveCount = shortResult!['attention_mask']!.where((val) => val == 1).length;
      final longActiveCount = longResult!['attention_mask']!.where((val) => val == 1).length;

      expect(longActiveCount, greaterThan(shortActiveCount));
    });
  });
}
