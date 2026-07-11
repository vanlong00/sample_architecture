import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/config/env.dart';
import 'package:sample_architecture/core/config/app_config.dart';

void main() {
  test('dev config bật logging và baseUrl dev', () {
    final c = AppConfig.fromEnv(AppEnv.dev);
    expect(c.env, AppEnv.dev);
    expect(c.enableLogging, isTrue);
    expect(c.baseUrl, 'https://dev.api.example.com');
  });

  test('prod config tắt logging và baseUrl prod', () {
    final c = AppConfig.fromEnv(AppEnv.prod);
    expect(c.enableLogging, isFalse);
    expect(c.baseUrl, 'https://api.example.com');
  });
}
