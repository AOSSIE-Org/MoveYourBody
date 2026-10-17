import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dart_wordpiece/dart_wordpiece.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenizerServiceProvider = Provider((ref) => TokenizerService());

class TokenizerService {
  static const _vocabAsset = 'assets/models/vocab.txt';
  static const maxLength = 128;

  WordPieceTokenizer? _tokenizer;
  Future<void>? _initFuture;

  bool get isInitialized => _tokenizer != null;

  /// Loads the vocab once. Errors are rethrown so callers know the pipeline
  /// is unusable instead of failing silently on every [encode] call.
  Future<void> init() {
    if (_tokenizer != null) return Future.value();
    return _initFuture ??= _load().whenComplete(() {
      if (_tokenizer == null) _initFuture = null;
    });
  }

  Future<void> _load() async {
    try {
      debugPrint("Tokenizer: Loading vocab...");
      final vocabContent = await rootBundle.loadString(_vocabAsset);
      final vocab = VocabLoader.fromString(vocabContent);

      final tokenizer = WordPieceTokenizer(
        vocab: vocab,
        config: TokenizerConfig(maxLength: maxLength, normalizeText: true),
      );
      _tokenizer = tokenizer;
      debugPrint(
        "Tokenizer: Initialized with vocab size: ${tokenizer.vocabSize}",
      );
    } catch (e) {
      debugPrint("Tokenizer: Initialization Error: $e");
      rethrow;
    }
  }

  /// Encodes [query] and strips trailing padding, so the model only runs over
  /// real tokens (short tags are usually < 10 tokens instead of 128).
  Map<String, Int64List>? encode(String query) {
    final tokenizer = _tokenizer;
    if (tokenizer == null) {
      debugPrint("Tokenizer: encode called before init.");
      return null;
    }
    try {
      final output = tokenizer.encode(query);
      final realLength = output.realLength;
      if (realLength == 0) return null;

      return {
        'input_ids': Int64List.sublistView(output.inputIdsInt64, 0, realLength),
        'attention_mask': Int64List.sublistView(
          output.attentionMaskInt64,
          0,
          realLength,
        ),
        'token_type_ids': Int64List.sublistView(
          output.tokenTypeIdsInt64,
          0,
          realLength,
        ),
      };
    } catch (e) {
      debugPrint("Tokenizer: Encoding Error: $e");
      return null;
    }
  }
}
