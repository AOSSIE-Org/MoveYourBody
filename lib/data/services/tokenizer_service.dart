import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dart_wordpiece/dart_wordpiece.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/utils/constants/app_constants.dart';

final tokenizerServiceProvider = Provider((ref) => TokenizerService());

class TokenizerService {
  late WordPieceTokenizer _tokenizer;
  bool _isInitialized = false;

  Future<void> init() async {
    try {
      debugPrint("Tokenizer: Loading vocab...");
      final vocabContent = await rootBundle.loadString(AppAssets.vocabTxt);
      final vocab = VocabLoader.fromString(vocabContent);

      _tokenizer = WordPieceTokenizer(
        vocab: vocab,
        config: const TokenizerConfig(
          maxLength: AiConstants.maxSequenceLength,
          normalizeText: true,
        ),
      );

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
      final output = _tokenizer.encode(query);
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
