import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:move_your_body/features/home/services/stt_service.dart';
import 'package:move_your_body/features/home/services/tts_service.dart';

enum VoiceCommand { resume, pause, skip }
class VoiceCommandService {
  VoiceCommandService({required TtsService ttsService})
      : _ttsService = ttsService;

  final TtsService _ttsService;
  final SttService _sttService = SttService();
  ValueChanged<VoiceCommand>? onCommandDetected;

  bool _isActive = false;
  static const _postTtsBuffer = Duration(milliseconds: 500);

  static const Map<String, VoiceCommand> _commandKeywords = {
    'start': VoiceCommand.resume,
    'resume': VoiceCommand.resume,
    'play': VoiceCommand.resume,
    'go': VoiceCommand.resume,
    'continue': VoiceCommand.resume,
    'pause': VoiceCommand.pause,
    'stop': VoiceCommand.pause,
    'wait': VoiceCommand.pause,
    'hold': VoiceCommand.pause,
    'skip': VoiceCommand.skip,
    'next': VoiceCommand.skip,
  };

  static const Map<VoiceCommand, String> _confirmations = {
    VoiceCommand.resume: 'Resuming',
    VoiceCommand.pause: 'Paused',
    VoiceCommand.skip: 'Skipping',
  };
  Future<bool> init() async {
    final available = await _sttService.init();
    _ttsService.onSpeakingChanged = _onTtsSpeakingChanged;

    return available;
  }
  void startListening() {
    _isActive = true;
    if (!_ttsService.isSpeaking) {
      _sttService.startListening(onResult: _onSttResult);
    }
  }
  void stopListening() {
    _isActive = false;
    _sttService.stopListening();
  }
  void dispose() {
    stopListening();
    _ttsService.onSpeakingChanged = null;
    _sttService.dispose();
  }

  void _onTtsSpeakingChanged(bool isSpeaking) {
    if (!_isActive) return;

    if (isSpeaking) {
      _sttService.stopListening();
    } else {
      Future.delayed(_postTtsBuffer, () {
        if (_isActive && !_ttsService.isSpeaking) {
          _sttService.startListening(onResult: _onSttResult);
        }
      });
    }
  }

  void _onSttResult(String recognizedText) {
    debugPrint('STT heard: "$recognizedText"');

    final command = _detectIntent(recognizedText);
    if (command == null) return;

    debugPrint('Voice command detected: ${command.name}');
    _sttService.stopListening();
    _ttsService.stop();
    onCommandDetected?.call(command);
    _speakConfirmationAndRestart(command);
  }
  VoiceCommand? _detectIntent(String text) {
    final normalized = text.toLowerCase().trim();

    for (final entry in _commandKeywords.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }
  Future<void> _speakConfirmationAndRestart(VoiceCommand command) async {
    final message = _confirmations[command];
    if (message != null) {
      await _ttsService.speakConfirmation(message);
    }
    if (_isActive) {
      Future.delayed(_postTtsBuffer, () {
        if (_isActive && !_ttsService.isSpeaking) {
          _sttService.startListening(onResult: _onSttResult);
        }
      });
    }
  }
}
