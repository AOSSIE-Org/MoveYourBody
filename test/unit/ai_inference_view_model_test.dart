import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/ai_inference/view_model/ai_inference_view_model.dart';
import 'package:move_your_body/features/ai_inference/repositories/ai_repository.dart';
import 'package:move_your_body/features/ai_inference/repositories/tag_setup_repository.dart';

class MockAiModelRepository extends Fake implements AiModelRepository {
  bool initModelCalled = false;
  Uint8List? embeddingToReturn;
  String? lastGeneratedFor;

  @override
  Future<void> initModel() async {
    initModelCalled = true;
  }

  @override
  Future<Uint8List?> generateEmbedding(String text) async {
    lastGeneratedFor = text;
    return embeddingToReturn;
  }
}

class MockTagSetupRepository extends Fake implements TagSetupRepository {
  bool processAndSeedTagsCalled = false;

  @override
  Future<void> processAndSeedTags() async {
    processAndSeedTagsCalled = true;
  }
}

void main() {
  group('AiInferenceViewModel — State Management Tests', () {
    late MockAiModelRepository mockAiRepo;
    late MockTagSetupRepository mockTagRepo;
    late ProviderContainer container;

    setUp(() {
      mockAiRepo = MockAiModelRepository();
      mockTagRepo = MockTagSetupRepository();
      container = ProviderContainer(
        overrides: [
          aiModelRepositoryProvider.overrideWithValue(mockAiRepo),
          tagSetupRepositoryProvider.overrideWithValue(mockTagRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    group('Initial State', () {
      test('engine is not ready on creation', () {
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.isReady, isFalse);
      });

      test('not processing on creation', () {
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.isProcessing, isFalse);
      });

      test('no result on creation', () {
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.bestMatchResult, isNull);
      });
    });

    group('initializeAiAndTags', () {
      test('calls initModel on AI repository', () async {
        await container.read(aiInferenceViewModelProvider.notifier).initializeAiAndTags();
        expect(mockAiRepo.initModelCalled, isTrue);
      });

      test('calls processAndSeedTags on tag repository', () async {
        await container.read(aiInferenceViewModelProvider.notifier).initializeAiAndTags();
        expect(mockTagRepo.processAndSeedTagsCalled, isTrue);
      });

      test('sets isReady to true after successful initialization', () async {
        await container.read(aiInferenceViewModelProvider.notifier).initializeAiAndTags();
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.isReady, isTrue);
      });
    });

    group('setEngineReady', () {
      test('sets isReady to true', () {
        container.read(aiInferenceViewModelProvider.notifier).setEngineReady();
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.isReady, isTrue);
      });
    });

    group('processUserQuery — state transitions', () {
      setUp(() {
        container.read(aiInferenceViewModelProvider.notifier).setEngineReady();
      });

      test('does nothing when engine is not ready', () async {
        final freshContainer = ProviderContainer(
          overrides: [
            aiModelRepositoryProvider.overrideWithValue(mockAiRepo),
            tagSetupRepositoryProvider.overrideWithValue(mockTagRepo),
          ],
        );
        await freshContainer.read(aiInferenceViewModelProvider.notifier).processUserQuery(
              query: 'test',
              targetEmbeddingsDb: {'Tag A': [1.0, 0.0]},
            );
        expect(mockAiRepo.lastGeneratedFor, isNull);
        freshContainer.dispose();
      });

      test('calls generateEmbedding with the user query text', () async {
        mockAiRepo.embeddingToReturn = Float32List.fromList([1.0, 0.0]).buffer.asUint8List();
        await container.read(aiInferenceViewModelProvider.notifier).processUserQuery(
              query: 'knee pain',
              targetEmbeddingsDb: {'knee_injury': [1.0, 0.0]},
            );
        expect(mockAiRepo.lastGeneratedFor, equals('knee pain'));
      });

      test('sets isProcessing to false after successful query', () async {
        mockAiRepo.embeddingToReturn = Float32List.fromList([1.0, 0.0]).buffer.asUint8List();
        await container.read(aiInferenceViewModelProvider.notifier).processUserQuery(
              query: 'test query',
              targetEmbeddingsDb: {'Tag A': [1.0, 0.0]},
            );
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.isProcessing, isFalse);
      });

      test('updates bestMatchResult after successful query', () async {
        mockAiRepo.embeddingToReturn = Float32List.fromList([1.0, 0.0]).buffer.asUint8List();
        await container.read(aiInferenceViewModelProvider.notifier).processUserQuery(
              query: 'test query',
              targetEmbeddingsDb: {'Tag A': [1.0, 0.0]},
            );
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.bestMatchResult, isNotNull);
        expect(state.bestMatchResult, isNot('Error parsing query'));
      });

      test('sets bestMatchResult to error message when embedding generation fails', () async {
        mockAiRepo.embeddingToReturn = null;
        await container.read(aiInferenceViewModelProvider.notifier).processUserQuery(
              query: 'invalid input',
              targetEmbeddingsDb: {'Tag A': [1.0, 0.0]},
            );
        final state = container.read(aiInferenceViewModelProvider);
        expect(state.bestMatchResult, equals('Error parsing query'));
        expect(state.isProcessing, isFalse);
      });
    });
  });
}
