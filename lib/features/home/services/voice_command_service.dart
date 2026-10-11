import 'dart:async';

import 'package:flutter/foundation.dart';

import 'tts_service.dart';
import 'voice_command_detector.dart';

enum VoiceCommand {
  resume,
  pause,
  skip,
}

class VoiceCommandService {
  VoiceCommandService({
    required TtsService ttsService,
  }) : _ttsService = ttsService;

  final TtsService _ttsService;

  late final VoiceCommandDetector _detector =
      VoiceCommandDetector(
    onCommandDetected: _onCommandDetected,
  );

  bool Function(VoiceCommand)? onCommandDetected;

  bool _isActive = false;
  bool _isInitialized = false;

  static const _postTtsBuffer =
      Duration(milliseconds: 500);

  static const Map<VoiceCommand, String> _confirmations = {
    VoiceCommand.resume: 'Resuming',
    VoiceCommand.pause: 'Paused',
    VoiceCommand.skip: 'Skipping',
  };

  Future<bool> init() async {
    try {
      await _detector.init();

      _ttsService.onSpeakingChanged =
          _onTtsSpeakingChanged;

      _isInitialized = true;

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'VoiceCommandService init error: $e',
      );
      debugPrint('$stackTrace');

      return false;
    }
  }

  void startListening() {
    if (!_isInitialized) {
      debugPrint(
        'VoiceCommandService: not initialized',
      );
      return;
    }

    if (_isActive) return;

    _isActive = true;

    if (!_ttsService.isSpeaking) {
      unawaited(_detector.start());
    }
  }

  void stopListening() {
    _isActive = false;

    unawaited(_detector.stop());
  }

  void dispose() {
    _isActive = false;

    _ttsService.onSpeakingChanged = null;

    unawaited(_detector.dispose());
  }

  void _onTtsSpeakingChanged(bool isSpeaking) {
    if (!_isActive) return;

    if (isSpeaking) {
      unawaited(_detector.stop());
      return;
    }

    Future.delayed(_postTtsBuffer, () {
      if (!_isActive) return;

      if (_ttsService.isSpeaking) return;

      unawaited(_detector.start());
    });
  }

  void _onCommandDetected(
    VoiceCommand command,
  ) {
    if (!_isActive) return;

    debugPrint(
      'VoiceCommandService: detected ${command.name}',
    );

    final shouldConfirm = onCommandDetected?.call(command) ?? true;

    if (shouldConfirm) {
      _speakConfirmationAndRestart(command);
    }
  }

  Future<void> _speakConfirmationAndRestart(
    VoiceCommand command,
  ) async {
    final message = _confirmations[command];

    if (message == null) return;
    await _detector.stop();

    if (!_isActive) return;

    await _ttsService.speakConfirmation(
      message,
    );

    if (!_isActive) return;

    Future.delayed(_postTtsBuffer, () {
      if (!_isActive) return;

      if (!_ttsService.isSpeaking) {
        unawaited(_detector.start());
      }
    });
  }
}