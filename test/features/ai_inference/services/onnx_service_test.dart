import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/ai_inference/services/onnx_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('OnnxService Tests', () {
    late OnnxService onnxService;

    setUp(() {
      onnxService = OnnxService();
    });

    test(
      'runInference returns empty list if session is not initialized',
      () async {
        final dummyInput = Int64List.fromList([1, 2]);

        final result = await onnxService.runInference(
          dummyInput,
          dummyInput,
          dummyInput,
        );

        expect(result, isEmpty);
      },
    );

    test(
      'init should throw an error if model asset is missing or runtime is unavailable in test environment',
      () async {
        expect(() async => await onnxService.init(), throwsA(isA<dynamic>()));
      },
    );
  });
}
