import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metronome/metronome_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('setPan sends the pan to the native side and rejects out-of-range values', () async {
    final calls = <MethodCall>[];
    final platform = MethodChannelMetronome();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      platform.methodChannel,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(platform.methodChannel, null),
    );

    await platform.setPan(-1);
    expect(calls.last.method, 'setPan');
    expect((calls.last.arguments as Map<Object?, Object?>)['pan'], -1.0);

    await platform.setPan(0.5);
    expect((calls.last.arguments as Map<Object?, Object?>)['pan'], 0.5);

    expect(() => platform.setPan(1.5), throwsException);
    expect(() => platform.setPan(-1.5), throwsException);
  });
}
