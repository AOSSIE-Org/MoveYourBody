# On-Device AI Pipeline

MoveYourBody matches free-text user input (custom goals and health issues) to the goal and injury tags used by the exercise catalogue. Everything runs on the device. No text leaves the phone.

## Data sources

| File | What it is | Read by |
|---|---|---|
| `assets/models/model_quantized.onnx` | Quantized [all-MiniLM-L6-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2) sentence-transformer, exported to ONNX | `OnnxService` (`lib/features/ai_inference/services/onnx_service.dart`) |
| `assets/models/vocab.txt` | BERT uncased WordPiece vocabulary (30,522 tokens) that ships with the model | `TokenizerService` (`lib/features/ai_inference/services/tokenizer_service.dart`) |
| `assets/exercises/exercises.json` | Exercise catalogue. `goal_tags` and `contraindications` are `;`-separated `snake_case` tags | `TagSetupRepository.processAndSeedTags` |
| `tags` table (SQLite) | Cached tag embeddings (Float32 bytes) | `TagSetupRepository.findTopMatches` |

## Pipeline

```
exercises.json ──► unique goal / injury tags ──┐
                                               ▼
user text ──► TokenizerService.prepareText ──► Dart WordPiece ──► ONNX model ──► embedding
                                                                                   │
                         tags table (cached tag embeddings) ◄──────────────────────┤
                                                                                   ▼
                                                     cosine similarity ──► top-k tags above threshold
```

1. **Tag extraction:** `processAndSeedTags` collects unique tags from `exercises.json`, embeds any that are not cached yet, and stores them in the `tags` table.
2. **Text preparation:** `TokenizerService.prepareText` replaces `_` with spaces, so `knee_pain` is tokenized as "knee pain" (see [Tokenizer parity](#tokenizer-parity)).
3. **Tokenization:** `dart_wordpiece` with `maxLength: 128` and `normalizeText: true`. Produces `input_ids`, `attention_mask` and `token_type_ids`.
4. **Inference:** the model returns `last_hidden_state` with shape `[1, sequence_length, 384]`.
5. **Matching:** `findTopMatches` compares the user embedding with every cached tag of the same type and returns the top `limit` tags whose cosine similarity is at least `threshold`.

## Model I/O

| Name | Shape | Type |
|---|---|---|
| `input_ids` | `[batch, seq]` | int64 |
| `attention_mask` | `[batch, seq]` | int64 |
| `token_type_ids` | `[batch, seq]` | int64 |
| `last_hidden_state` (output) | `[batch, seq, 384]` | float32 |

## Tokenizer parity

The model was trained with the reference BERT uncased tokenizer. The app uses the `dart_wordpiece` package, which normalizes text differently:

| Input | Reference BERT tokenizer | Dart WordPiece | Effect |
|---|---|---|---|
| `_` (underscore) | separate token `_` | kept inside the word (`##_`) | **Major.** Every multi-word tag breaks: `ankle_injury` → `ankle ##_ ##in ##ju ##ry` |
| Other punctuation (`! - ( ) & '`) | separate tokens | removed | Minor for short queries |
| Accented letters (`é`) | accent stripped (`e`) | `[UNK]` | Minor, rare in this app |

Results from `notebooks/onnx_pipeline_validation.ipynb`:

| Tags fed to the tokenizer | Token ids identical to reference | Embedding cosine vs reference (multi-word tags) |
|---|---|---|
| As stored (`snake_case`) | 41 / 133 | mean 0.63, min 0.30 |
| `_` replaced by spaces (`prepareText`) | 133 / 133 | 1.00 |

`TokenizerService.prepareText` applies this mapping to all input. `test/tokenizer_parity_test.dart` checks the real Dart tokenizer against reference ids for every tag and a set of sample queries, so a change to the tokenizer, its config or the vocab that breaks parity fails the test suite.

## Pooling and threshold

all-MiniLM-L6-v2 produces sentence embeddings by **mean pooling** `last_hidden_state` over real tokens (using `attention_mask`) and then **L2 normalizing**. Using the `[CLS]` token vector instead makes nearly every tag look similar:

| Query | Tags scoring ≥ 0.60 with `[CLS]` | With mean pooling |
|---|---|---|
| "my knee hurts" | 88 / 89 | 5 / 89 |
| "I want to lose belly fat" | 35 / 44 | 0 / 44 |
| "reduce stress" | 44 / 44 | 1 / 44 |

With mean pooling, related tags typically score 0.45–0.85, exact matches ~1.0, and unrelated tags below 0.40. At a threshold of 0.60, 3 of 12 sample queries get no match. At 0.45, every sample query keeps its best tag. The notebook prints the full per-query table (section 7).

Mean pooling and the threshold change are in [#39](https://github.com/AOSSIE-Org/MoveYourBody/pull/39).

## Reproducing the analysis

The notebook reads the same asset files as the app, so it stays in sync with whatever model, vocab and exercise data are checked in.

```bash
cd notebooks
pip install -r requirements.txt
jupyter notebook onnx_pipeline_validation.ipynb
```

Run all cells. Section 8 rewrites `test/fixtures/tokenizer_parity.json`. After changing the vocab, the tokenizer config or `exercises.json`, re-run the notebook and then:

```bash
flutter test test/tokenizer_parity_test.dart
```
