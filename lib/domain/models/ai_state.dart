import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/ai_state.freezed.dart';

@freezed
abstract class AiState with _$AiState {
  const factory AiState({
    @Default(false) bool isReady,
    @Default(false) bool isProcessing,
    String? bestMatchResult,
  }) = _AiState;
}
