import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dart_wordpiece/dart_wordpiece.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenizerServiceProvider = Provider((ref) => TokenizerService());

class TokenizerService {
  late WordPieceTokenizer _tokenizer;
  bool _isInitialized = false;

  /// Builds the tokenizer used for all-MiniLM-L6-v2 from `vocab.txt` content.
  static WordPieceTokenizer buildTokenizer(String vocabContent) {
    return WordPieceTokenizer(
      vocab: VocabLoader.fromString(vocabContent),
      config: TokenizerConfig(maxLength: 128, normalizeText: true),
    );
  }

  /// Maps app text to the form the model was trained on.
  ///
  /// Tags are stored as snake_case ids (e.g. `knee_pain`). The Dart
  /// normalizer keeps `_` inside words, which splits every multi-word tag into
  /// sub-word noise (`##_ ##in ##ju ##ry`). Replacing `_` with a space gives
  /// the same token ids as the reference BERT tokenizer. See
  /// `notebooks/onnx_pipeline_validation.ipynb`.
  static String prepareText(String text) => text.replaceAll('_', ' ');

  Future<void> init() async {
    try {
      debugPrint("Tokenizer: Loading vocab...");
      final vocabContent = await rootBundle.loadString(
        'assets/models/vocab.txt',
      );
      _tokenizer = buildTokenizer(vocabContent);

      _isInitialized = true;
      debugPrint(
        "Tokenizer: Initialized with vocab size: ${_tokenizer.vocabSize}",
      );
    } catch (e) {
      debugPrint("Tokenizer: Initialization Error: $e");
    }
  }

  Map<String, Int64List>? encode(String query) {
    try {
      if (!_isInitialized) return null;
      final output = _tokenizer.encode(prepareText(query));
      return {
        'input_ids': output.inputIdsInt64,
        'attention_mask': output.attentionMaskInt64,
        'token_type_ids': output.tokenTypeIdsInt64,
      };
    } catch (e) {
      debugPrint("Tokenizer: Encoding Error: $e");
      return null;
    }
  }
}
