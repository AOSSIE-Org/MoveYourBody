import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/ai_inference/repositories/ai_repository.dart';
import 'package:move_your_body/features/ai_inference/services/onnx_service.dart';
import 'package:move_your_body/features/ai_inference/services/tokenizer_service.dart';

class MockOnnxService extends Mock implements OnnxService {}

class MockTokenizerService extends Mock implements TokenizerService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Int64List(0));
  });

  group('AiModelRepository Tests', () {
    late ProviderContainer container;
    late MockOnnxService mockOnnxService;
    late MockTokenizerService mockTokenizerService;

    setUp(() {
      mockOnnxService = MockOnnxService();
      mockTokenizerService = MockTokenizerService();

      container = ProviderContainer(
        overrides: [
          onnxServiceProvider.overrideWithValue(mockOnnxService),
          tokenizerServiceProvider.overrideWithValue(mockTokenizerService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'initModel should initialize both tokenizer and onnx services',
      () async {
        when(() => mockTokenizerService.init()).thenAnswer((_) async {});
        when(() => mockOnnxService.init()).thenAnswer((_) async {});

        final repository = container.read(aiModelRepositoryProvider);
        await repository.initModel();

        verify(() => mockTokenizerService.init()).called(1);
        verify(() => mockOnnxService.init()).called(1);
      },
    );

    test('generateEmbedding should return null for empty text', () async {
      final repository = container.read(aiModelRepositoryProvider);

      final result = await repository.generateEmbedding('   ');

      expect(result, isNull);
      verifyNever(() => mockTokenizerService.encode(any()));
    });

    test(
      'generateEmbedding should return Uint8List when text is valid',
      () async {
        final repository = container.read(aiModelRepositoryProvider);
        final dummyText = 'burn fat';
        final mockTokens = {
          'input_ids': Int64List.fromList([1, 2, 3]),
          'attention_mask': Int64List.fromList([1, 1, 1]),
          'token_type_ids': Int64List.fromList([0, 0, 0]),
        };

        when(
          () => mockTokenizerService.encode(dummyText),
        ).thenReturn(mockTokens);

        when(
          () => mockOnnxService.runInference(
            mockTokens['input_ids']!,
            mockTokens['attention_mask']!,
            mockTokens['token_type_ids']!,
          ),
        ).thenAnswer((_) async => [0.5, -0.5]);

        final result = await repository.generateEmbedding(dummyText);

        expect(result, isA<Uint8List>());

        verify(() => mockTokenizerService.encode(dummyText)).called(1);
        verify(
          () => mockOnnxService.runInference(any(), any(), any()),
        ).called(1);

        expect(result!.lengthInBytes, 8);
      },
    );
  });
}
