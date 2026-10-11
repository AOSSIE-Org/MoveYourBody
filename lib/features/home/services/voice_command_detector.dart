import 'dart:async';
import 'dart:math' as math;
import 'package:fftea/fftea.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'voice_command_service.dart';

class VoiceCommandDetector {
  VoiceCommandDetector({
    required this.onCommandDetected,
  });

  final ValueChanged<VoiceCommand> onCommandDetected;

  final AudioRecorder _recorder = AudioRecorder();

  StreamSubscription<Uint8List>? _audioSubscription;

  final List<double> _audioBuffer = [];
  final List<int> _pendingBytes = [];

  final Map<VoiceCommand, List<List<List<double>>>> _templates = {};

  bool _isRunning = false;
  bool _isProcessing = false;

  DateTime? _lastDetection;

  static const int sampleRate = 16000;
  static const int channels = 1;

  static const int bufferSamples = sampleRate * 2;

  static const int processingIntervalMs = 250;

  static const double defaultThreshold = 2.5;

  static const Duration cooldown = Duration(milliseconds: 1200);

  Timer? _processingTimer;

  Future<void> init() async {
    await _loadTemplates();
  }

  Future<void> start() async {
    if (_isRunning) return;

    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      debugPrint('VoiceDetector: microphone permission denied');
      return;
    }

    _isRunning = true;

    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: sampleRate,
        numChannels: channels,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      ),
    );

    _audioSubscription = stream.listen(
      _onAudioChunk,
      onError: (error) {
        debugPrint('VoiceDetector stream error: $error');
      },
    );

    _processingTimer = Timer.periodic(
      const Duration(milliseconds: processingIntervalMs),
      (_) => _processCurrentBuffer(),
    );

    debugPrint('VoiceDetector: listening started');
  }

  Future<void> stop() async {
    if (!_isRunning) return;

    _isRunning = false;

    _processingTimer?.cancel();
    _processingTimer = null;

    await _audioSubscription?.cancel();
    _audioSubscription = null;

    try {
      await _recorder.stop();
    } catch (e) {
      debugPrint('VoiceDetector stop error: $e');
    }

    _audioBuffer.clear();
    _pendingBytes.clear();

    debugPrint('VoiceDetector: listening stopped');
  }

  Future<void> dispose() async {
    await stop();
    _templates.clear();
    await _recorder.dispose();
  }

  void _onAudioChunk(Uint8List chunk) {
    if (!_isRunning) return;

    _pendingBytes.addAll(chunk);

    final sampleCount = _pendingBytes.length ~/ 2;

    if (sampleCount == 0) return;

    final samples = List<double>.filled(sampleCount, 0);

    for (int i = 0; i < sampleCount; i++) {
      final lo = _pendingBytes[i * 2];
      final hi = _pendingBytes[i * 2 + 1];

      int value = lo | (hi << 8);

      if (value >= 0x8000) {
        value -= 0x10000;
      }

      samples[i] = value / 32768.0;
    }

    _pendingBytes.removeRange(0, sampleCount * 2);

    _audioBuffer.addAll(samples);

    if (_audioBuffer.length > bufferSamples) {
      final removeCount = _audioBuffer.length - bufferSamples;
      _audioBuffer.removeRange(0, removeCount);
    }
  }

  void _processCurrentBuffer() {
    if (!_isRunning || _isProcessing) return;

    if (_audioBuffer.length < sampleRate ~/ 2) {
      return;
    }

    _processAsync();
  }

  Future<void> _processAsync() async {
    if (_isProcessing) return;

    _isProcessing = true;

    try {
      final audio = List<double>.from(_audioBuffer);

      final trimmed = _trimSilence(audio);
      if (trimmed.length < sampleRate ~/ 5) {
        return;
      }

      final liveMfcc = _extractMfcc(trimmed);

      if (liveMfcc.isEmpty) return;

      VoiceCommand? bestCommand;
      double bestDistance = double.infinity;

      for (final entry in _templates.entries) {
        for (final template in entry.value) {
          final distance = _dtwDistance(liveMfcc, template);

          if (distance < bestDistance) {
            bestDistance = distance;
            bestCommand = entry.key;
          }
        }
      }

      debugPrint(
        'VoiceDetector: best=${bestCommand?.name} '
        'distance=${bestDistance.toStringAsFixed(3)}',
      );

      if (bestCommand == null) return;

      final now = DateTime.now();

      if (_lastDetection != null &&
          now.difference(_lastDetection!) < cooldown) {
        return;
      }

      if (bestDistance <= defaultThreshold) {
        _lastDetection = now;

        debugPrint(
          'VoiceDetector: COMMAND ${bestCommand.name} '
          'distance=${bestDistance.toStringAsFixed(3)}',
        );

        onCommandDetected(bestCommand);
      }
    } catch (e, stackTrace) {
      debugPrint('VoiceDetector processing error: $e');
      debugPrint('$stackTrace');
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _loadTemplates() async {
    _templates.clear();

    await _loadTemplate(
      VoiceCommand.resume,
      'assets/voices/start.wav',
    );

    await _loadTemplate(
      VoiceCommand.pause,
      'assets/voices/stop.wav',
    );

    await _loadTemplate(
      VoiceCommand.skip,
      'assets/voices/skip.wav',
    );

    debugPrint(
      'VoiceDetector: loaded '
      '${_templates.values.fold<int>(0, (sum, list) => sum + list.length)} '
      'templates',
    );
  }

  Future<void> _loadTemplate(
    VoiceCommand command,
    String assetPath,
  ) async {
    try {
      final data = await rootBundle.load(assetPath);

      final samples = _decodeWavPcm16(
        data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        ),
      );

      final trimmed = _trimSilence(samples);

      if (trimmed.isEmpty) {
        debugPrint('VoiceDetector: empty template $assetPath');
        return;
      }

      final mfcc = _extractMfcc(trimmed);

      if (mfcc.isNotEmpty) {
        _templates.putIfAbsent(command, () => []).add(mfcc);

        debugPrint(
          'VoiceDetector: loaded $command from $assetPath '
          '(${samples.length} samples)',
        );
      }
    } catch (e) {
      debugPrint(
        'VoiceDetector: failed to load $assetPath: $e',
      );
    }
  }

  List<double> _decodeWavPcm16(Uint8List bytes) {
    if (bytes.length < 44) {
      throw FormatException('Invalid WAV: file too small');
    }

    final data = ByteData.sublistView(bytes);

    final riff = String.fromCharCodes(bytes.sublist(0, 4));
    final wave = String.fromCharCodes(bytes.sublist(8, 12));

    if (riff != 'RIFF' || wave != 'WAVE') {
      throw FormatException('Only RIFF/WAVE files are supported');
    }

    int? audioFormat;
    int? numChannels;
    int? sampleRate;
    int? bitsPerSample;

    int dataOffset = -1;
    int dataLength = 0;

    int offset = 12;

    while (offset + 8 <= bytes.length) {
      final chunkId =
          String.fromCharCodes(bytes.sublist(offset, offset + 4));

      final chunkSize = data.getUint32(
        offset + 4,
        Endian.little,
      );

      final chunkDataStart = offset + 8;

      if (chunkId == 'fmt ') {
        if (chunkDataStart + 16 > bytes.length) {
          throw FormatException('Invalid WAV fmt chunk');
        }

        audioFormat = data.getUint16(
          chunkDataStart,
          Endian.little,
        );

        numChannels = data.getUint16(
          chunkDataStart + 2,
          Endian.little,
        );

        sampleRate = data.getUint32(
          chunkDataStart + 4,
          Endian.little,
        );

        bitsPerSample = data.getUint16(
          chunkDataStart + 14,
          Endian.little,
        );
      } else if (chunkId == 'data') {
        dataOffset = chunkDataStart;
        dataLength = math.min(
          chunkSize,
          bytes.length - dataOffset,
        );
        break;
      }
      offset = chunkDataStart + chunkSize + (chunkSize.isOdd ? 1 : 0);
    }

    if (audioFormat != 1) {
      throw FormatException('WAV must contain uncompressed PCM');
    }

    if (numChannels != 1) {
      throw FormatException('WAV must be mono');
    }

    if (sampleRate != sampleRateExpected) {
      throw FormatException(
        'WAV must be 16 kHz. Found $sampleRate Hz',
      );
    }

    if (bitsPerSample != 16) {
      throw FormatException('WAV must be 16-bit PCM');
    }

    if (dataOffset < 0 || dataLength <= 0) {
      throw FormatException('WAV data chunk not found');
    }

    final sampleCount = dataLength ~/ 2;
    final samples = List<double>.filled(sampleCount, 0);

    for (int i = 0; i < sampleCount; i++) {
      final value = data.getInt16(
        dataOffset + i * 2,
        Endian.little,
      );

      samples[i] = value / 32768.0;
    }

    return samples;
  }

  static const int sampleRateExpected = 16000;

  List<double> _trimSilence(List<double> audio) {
    if (audio.isEmpty) return [];

    const frameSize = 320;
    const hopSize = 160;

    final frameRms = <double>[];

    for (
      int start = 0;
      start + frameSize <= audio.length;
      start += hopSize
    ) {
      double sum = 0;

      for (int i = 0; i < frameSize; i++) {
        final x = audio[start + i];
        sum += x * x;
      }

      frameRms.add(math.sqrt(sum / frameSize));
    }

    if (frameRms.isEmpty) return audio;

    final maxRms = frameRms.reduce(math.max);

    if (maxRms < 0.01) {
      return [];
    }

    final threshold = math.max(0.008, maxRms * 0.15);

    int first = 0;
    int last = frameRms.length - 1;

    while (first < frameRms.length &&
        frameRms[first] < threshold) {
      first++;
    }

    while (last >= 0 && frameRms[last] < threshold) {
      last--;
    }

    if (first > last) return [];

    final startSample = math.max(0, first * hopSize);
    final endSample = math.min(
      audio.length,
      last * hopSize + frameSize,
    );

    return audio.sublist(startSample, endSample);
  }

  List<List<double>> _extractMfcc(List<double> audio) {
    const frameSize = 400;
    const hopSize = 160;
    const fftSize = 512;

    const filterCount = 26;
    const coefficientCount = 13;

    if (audio.length < frameSize) {
      return [];
    }

    final fft = FFT(fftSize);

    final hamming = List<double>.generate(
      frameSize,
      (i) =>
          0.54 -
          0.46 *
              math.cos(
                2 * math.pi * i / (frameSize - 1),
              ),
    );

    final filterBank = _createMelFilterBank(
      filterCount,
      fftSize,
      sampleRate,
    );

    final features = <List<double>>[];

    for (
      int start = 0;
      start + frameSize <= audio.length;
      start += hopSize
    ) {
      final frame = List<double>.filled(fftSize, 0);

      for (int i = 0; i < frameSize; i++) {
        final previous = i == 0 ? 0.0 : audio[start + i - 1];

        final emphasized =
            audio[start + i] - 0.97 * previous;

        frame[i] = emphasized * hamming[i];
      }

      final spectrum = fft
          .realFft(frame)
          .discardConjugates()
          .squareMagnitudes();

      final logMelEnergies = <double>[];

      for (final filter in filterBank) {
        double energy = 0;

        for (int k = 0;
            k < filter.length && k < spectrum.length;
            k++) {
          energy += spectrum[k] * filter[k];
        }

        logMelEnergies.add(
          math.log(math.max(energy, 1e-10)),
        );
      }

      final mfcc = List<double>.filled(
        coefficientCount,
        0,
      );

      for (int c = 0; c < coefficientCount; c++) {
        double sum = 0;

        for (int m = 0; m < filterCount; m++) {
          sum +=
              logMelEnergies[m] *
              math.cos(
                math.pi *
                    c *
                    (m + 0.5) /
                    filterCount,
              );
        }

        mfcc[c] = sum;
      }

      features.add(mfcc);
    }

    return _normalizeFeatures(features);
  }

  List<List<double>> _normalizeFeatures(
    List<List<double>> features,
  ) {
    if (features.isEmpty) return features;

    final dimension = features.first.length;
    final means = List<double>.filled(dimension, 0);
    final stds = List<double>.filled(dimension, 1);

    for (final frame in features) {
      for (int d = 0; d < dimension; d++) {
        means[d] += frame[d];
      }
    }

    for (int d = 0; d < dimension; d++) {
      means[d] /= features.length;
    }

    for (final frame in features) {
      for (int d = 0; d < dimension; d++) {
        final diff = frame[d] - means[d];
        stds[d] += diff * diff;
      }
    }

    for (int d = 0; d < dimension; d++) {
      stds[d] = math.sqrt(stds[d] / features.length);

      if (stds[d] < 1e-6) {
        stds[d] = 1;
      }
    }

    return features.map((frame) {
      return List<double>.generate(
        dimension,
        (d) => (frame[d] - means[d]) / stds[d],
      );
    }).toList();
  }

  List<List<double>> _createMelFilterBank(
    int filterCount,
    int fftSize,
    int sampleRate,
  ) {
    const lowFrequency = 300.0;
    final highFrequency = sampleRate / 2.0;

    double hzToMel(double hz) {
      return 2595 * math.log(1 + hz / 700) / math.ln10;
    }

    double melToHz(double mel) {
      return 700 * (math.pow(10, mel / 2595) - 1);
    }

    final lowMel = hzToMel(lowFrequency);
    final highMel = hzToMel(highFrequency);

    final melPoints = List<double>.generate(
      filterCount + 2,
      (i) =>
          lowMel +
          (highMel - lowMel) *
              i /
              (filterCount + 1),
    );

    final bins = melPoints.map((mel) {
      final hz = melToHz(mel);

      return ((fftSize + 1) * hz / sampleRate)
          .floor()
          .clamp(0, fftSize ~/ 2);
    }).toList();

    final filters = <List<double>>[];

    for (int m = 1; m <= filterCount; m++) {
      final left = bins[m - 1];
      final center = bins[m];
      final right = bins[m + 1];

      final filter = List<double>.filled(
        fftSize ~/ 2 + 1,
        0,
      );

      if (center > left) {
        for (int k = left; k < center; k++) {
          filter[k] =
              (k - left) / (center - left);
        }
      }

      if (right > center) {
        for (int k = center; k <= right; k++) {
          filter[k] =
              (right - k) / (right - center);
        }
      }

      filters.add(filter);
    }

    return filters;
  }

  double _dtwDistance(
    List<List<double>> a,
    List<List<double>> b,
  ) {
    final n = a.length;
    final m = b.length;

    if (n == 0 || m == 0) {
      return double.infinity;
    }

    final infinity = double.infinity;

    final previous = List<double>.filled(
      m + 1,
      infinity,
    );

    final current = List<double>.filled(
      m + 1,
      infinity,
    );

    previous[0] = 0;

    final band = math.max(
      15,
      (n - m).abs() + 10,
    );

    for (int i = 1; i <= n; i++) {
      current.fillRange(
        0,
        m + 1,
        infinity,
      );

      final start = math.max(1, i - band);
      final end = math.min(m, i + band);

      for (int j = start; j <= end; j++) {
        final cost = _euclideanDistance(
          a[i - 1],
          b[j - 1],
        );

        current[j] = cost +
            math.min(
              previous[j],
              math.min(
                current[j - 1],
                previous[j - 1],
              ),
            );
      }

      for (int j = 0; j <= m; j++) {
        previous[j] = current[j];
      }
    }

    final distance = previous[m];

    if (!distance.isFinite) {
      return double.infinity;
    }

    return distance / (n + m);
  }

  double _euclideanDistance(
    List<double> a,
    List<double> b,
  ) {
    final length = math.min(
      a.length,
      b.length,
    );

    double sum = 0;

    for (int i = 0; i < length; i++) {
      final diff = a[i] - b[i];
      sum += diff * diff;
    }

    return math.sqrt(sum);
  }
}