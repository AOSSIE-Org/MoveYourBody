import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _stt = SpeechToText();
  bool _isInitialized = false;
  bool _shouldListen = false;
  static const _restartDelay = Duration(milliseconds: 300);
  Future<bool> init() async {
    _isInitialized = await _stt.initialize(
      onStatus: _onStatus,
      onError: (error) => debugPrint('STT Error: ${error.errorMsg}'),
    );

    if (!_isInitialized) {
      debugPrint('STT: Speech recognition not available on this device');
    }

    return _isInitialized;
  }
  void startListening({required ValueChanged<String> onResult}) {
    if (!_isInitialized) {
      debugPrint('STT: Cannot listen — not initialized');
      return;
    }

    _shouldListen = true;
    _onResult = onResult;
    _beginSession();
  }

  void stopListening() {
    _shouldListen = false;
    _stt.stop();
  }

  bool get isListening => _stt.isListening;

  void dispose() {
    stopListening();
    _stt.cancel();
  }


  ValueChanged<String>? _onResult;

  void _beginSession() {
    if (!_shouldListen || !_isInitialized) return;

    _stt.listen(
      onResult: _handleResult,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: false,
        cancelOnError: false,
      ),
    );
  }

  void _handleResult(SpeechRecognitionResult result) {
    if (!result.finalResult) return;

    final text = result.recognizedWords.trim();
    if (text.isNotEmpty) {
      _onResult?.call(text);
    }
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (_shouldListen) {
        Future.delayed(_restartDelay, _beginSession);
      }
    }
  }
}
