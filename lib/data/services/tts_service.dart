import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

typedef SpeakingStateCallback = void Function(bool isSpeaking);

class TtsService {
  final FlutterTts _tts = FlutterTts();
  Timer? _gapTimer;
  Completer<void>? _gapCompleter;
  bool _isStopped = false;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;
  SpeakingStateCallback? onSpeakingChanged;

  Completer<void>? _speechCompleter;

  Future<void> init() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

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
    await _tts.stop();
  }

  Future<void> _speak(String text) async {
    if (_isStopped) return;

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
  }
}
