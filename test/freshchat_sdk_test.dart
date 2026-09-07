import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('freshchat_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await Freshchat.getSdkVersion, '42');
  });
}
