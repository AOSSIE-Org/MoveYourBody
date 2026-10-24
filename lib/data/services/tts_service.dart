import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'voice_command_detector.dart';

export 'voice_command_detector.dart' show VoiceCommand;

final ttsServiceProvider = Provider<TtsService>((ref) {
  final detector = ref.read(voiceCommandDetectorProvider);
  final service = TtsService(detector: detector);
  ref.onDispose(() => service.dispose());
  return service;
});

typedef SpeakingStateCallback = void Function(bool isSpeaking);

class TtsService {
  final FlutterTts _tts;
  final VoiceCommandDetector _detector;

  Timer? _gapTimer;
  Completer<void>? _gapCompleter;
  bool _isStopped = false;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;
  SpeakingStateCallback? onSpeakingChanged;

  Completer<void>? _speechCompleter;

  bool Function(VoiceCommand)? onCommandDetected;
  bool _isVoiceListeningActive = false;

  static const _postTtsBuffer = Duration(milliseconds: 500);

  static const Map<VoiceCommand, String> _confirmations = {
    VoiceCommand.resume: 'Resuming',
    VoiceCommand.pause: 'Paused',
    VoiceCommand.skip: 'Skipping',
  };

  TtsService({FlutterTts? tts, VoiceCommandDetector? detector})
    : _tts = tts ?? FlutterTts(),
      _detector = detector ?? VoiceCommandDetector() {
    _initTts();
    _detector.onCommandDetected = _onCommandDetected;
  }

  void _initTts() {
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.45);
    _tts.setPitch(1.0);

    _tts.setCompletionHandler(() {
      _setSpeaking(false);
      _speechCompleter?.complete();
    });

    _tts.setErrorHandler((error) {
      debugPrint('TTS Error: $error');
      _setSpeaking(false);
      _speechCompleter?.completeError(error);
    });
  }

  void startListening() {
    if (_isVoiceListeningActive) return;
    _isVoiceListeningActive = true;
    if (!_isSpeaking) {
      unawaited(_detector.start());
    }
  }

  void stopListening() {
    _isVoiceListeningActive = false;
    unawaited(_detector.stop());
  }

  void _onCommandDetected(VoiceCommand command) {
    if (!_isVoiceListeningActive) return;

    debugPrint('TtsService: detected ${command.name}');
    final shouldConfirm = onCommandDetected?.call(command) ?? true;
    if (shouldConfirm) {
      _speakConfirmationAndRestart(command);
    }
  }

  Future<void> _speakConfirmationAndRestart(VoiceCommand command) async {
    final message = _confirmations[command];
    if (message == null) return;

    await _detector.stop();
    if (!_isVoiceListeningActive) return;

    await speakConfirmation(message);
    if (!_isVoiceListeningActive) return;

    Future.delayed(_postTtsBuffer, () {
      if (!_isVoiceListeningActive) return;
      if (!_isSpeaking) {
        unawaited(_detector.start());
      }
    });
  }

  Future<void> speakInstructions(
    List<String> instructions, {
    int initialDelaySeconds = 2,
    int gapSeconds = 3,
  }) async {
    _isStopped = false;

    await _delaySeconds(initialDelaySeconds);
    if (_isStopped) return;

    for (int i = 0; i < instructions.length; i++) {
      await _speak(instructions[i]);
      if (_isStopped) return;

      if (i < instructions.length - 1) {
        await _delaySeconds(gapSeconds);
        if (_isStopped) return;
      }
    }
  }

  Future<void> speakConfirmation(String message) async {
    _isStopped = false;
    await _speak(message);
  }

  Future<void> stop() async {
    _isStopped = true;

    _gapTimer?.cancel();
    _gapTimer = null;

    if (_gapCompleter != null && !_gapCompleter!.isCompleted) {
      _gapCompleter!.complete();
    }
    _gapCompleter = null;

    if (_isSpeaking) {
      await _tts.stop();
      _setSpeaking(false);
      if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
        _speechCompleter!.complete();
      }
    }
  }

  Future<void> dispose() async {
    await stop();
    stopListening();
    await _tts.stop();
    await _detector.dispose();
  }

  Future<void> _speak(String text) async {
    if (_isStopped) return;

    unawaited(_detector.stop());

    _speechCompleter = Completer<void>();
    _setSpeaking(true);
    await _tts.speak(text);

    await _speechCompleter!.future;
  }

  Future<void> _delaySeconds(int seconds) {
    _gapCompleter = Completer<void>();
    _gapTimer = Timer(Duration(seconds: seconds), () {
      if (!_gapCompleter!.isCompleted) _gapCompleter!.complete();
    });
    return _gapCompleter!.future;
  }

  void _setSpeaking(bool value) {
    if (_isSpeaking == value) return;
    _isSpeaking = value;
    onSpeakingChanged?.call(value);

    if (!value && _isVoiceListeningActive) {
      Future.delayed(_postTtsBuffer, () {
        if (_isVoiceListeningActive && !_isSpeaking) {
          unawaited(_detector.start());
        }
      });
    }
  }
}
