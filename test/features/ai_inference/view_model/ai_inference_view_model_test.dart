import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/ai_inference/repositories/ai_repository.dart';
import 'package:move_your_body/features/ai_inference/view_model/ai_inference_view_model.dart';

class MockAiModelRepository extends Mock implements AiModelRepository {}

void main() {
  group('AiInferenceViewModel Tests', () {
    late ProviderContainer container;
    late MockAiModelRepository mockRepo;

    setUp(() {
      mockRepo = MockAiModelRepository();
      container = ProviderContainer(
        overrides: [aiModelRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should not be ready or processing', () {
      final state = container.read(aiInferenceViewModelProvider);
      expect(state.isReady, isFalse);
      expect(state.isProcessing, isFalse);
      expect(state.bestMatchResult, isNull);
    });

    test(
      'initializeAiAndTags should call initModel and set state to ready',
      () async {
        when(() => mockRepo.initModel()).thenAnswer((_) async {});

        final notifier = container.read(aiInferenceViewModelProvider.notifier);
        await notifier.initializeAiAndTags();

        verify(() => mockRepo.initModel()).called(1);
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.isReady, isTrue);
      },
    );

    test('setEngineReady should manually set engine to ready', () {
      final notifier = container.read(aiInferenceViewModelProvider.notifier);
      notifier.setEngineReady();

      final state = container.read(aiInferenceViewModelProvider);
      expect(state.isReady, isTrue);
    });

    test('processUserQuery should do nothing if engine is not ready', () async {
      final notifier = container.read(aiInferenceViewModelProvider.notifier);

      await notifier.processUserQuery(query: 'test', targetEmbeddingsDb: {});

      verifyNever(() => mockRepo.generateEmbedding(any()));
      final state = container.read(aiInferenceViewModelProvider);
      expect(state.isProcessing, isFalse);
    });

    test('processUserQuery should find the best match successfully', () async {
      final notifier = container.read(aiInferenceViewModelProvider.notifier);

      notifier.setEngineReady();

      final dummyDb = {
        'fat_burn': [1.0, 0.0, 0.0],
        'muscle_gain': [0.0, 1.0, 0.0],
      };

      final floatVector = Float32List.fromList([1.0, 0.0, 0.0]);
      final uint8Vector = floatVector.buffer.asUint8List();

      when(
        () => mockRepo.generateEmbedding('I want to lose weight'),
      ).thenAnswer((_) async => uint8Vector);

      await notifier.processUserQuery(
        query: 'I want to lose weight',
        targetEmbeddingsDb: dummyDb,
      );

      final state = container.read(aiInferenceViewModelProvider);
      expect(state.isProcessing, isFalse);
      expect(state.bestMatchResult, 'fat_burn');

      verify(
        () => mockRepo.generateEmbedding('I want to lose weight'),
      ).called(1);
    });

    test('processUserQuery should handle null embedding gracefully', () async {
      final notifier = container.read(aiInferenceViewModelProvider.notifier);
      notifier.setEngineReady();

      when(
        () => mockRepo.generateEmbedding('invalid'),
      ).thenAnswer((_) async => null);

      await notifier.processUserQuery(query: 'invalid', targetEmbeddingsDb: {});

      final state = container.read(aiInferenceViewModelProvider);
      expect(state.isProcessing, isFalse);
      expect(state.bestMatchResult, 'Error parsing query');
    });

    test('processUserQuery should catch exceptions from repository', () async {
      final notifier = container.read(aiInferenceViewModelProvider.notifier);
      notifier.setEngineReady();

      when(
        () => mockRepo.generateEmbedding('error_trigger'),
      ).thenThrow(Exception('Simulated Crash'));

      await notifier.processUserQuery(
        query: 'error_trigger',
        targetEmbeddingsDb: {},
      );

      final state = container.read(aiInferenceViewModelProvider);
      expect(state.isProcessing, isFalse);
      expect(state.bestMatchResult, 'Error occurred while processing query');
    });
  });
}
