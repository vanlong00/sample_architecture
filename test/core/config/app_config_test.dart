import 'package:flutter_test/flutter_test.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/config/app_config.dart';

void main() {
  test('dev config bật logging và baseUrl dev', () {
    final c = AppConfig.fromEnv(AppEnv.dev);
    expect(c.env, AppEnv.dev);
    expect(c.enableLogging, isTrue);
    expect(c.baseUrl, 'http://10.0.2.2:3000');
    expect(c.appName, 'Busmod (Dev)');
  });

  test('prod config tắt logging và baseUrl prod', () {
    final c = AppConfig.fromEnv(AppEnv.prod);
    expect(c.enableLogging, isFalse);
    expect(c.baseUrl, 'https://api.example.com');
  });
}
