import 'package:busmod/core/config/app_config.dart';
import 'package:busmod/core/config/env.dart';
import 'package:busmod/core/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('download Dio never follows redirects and accepts only 2xx', () {
    final o = buildDownloadDio(
      const AppConfig(
        env: AppEnv.prod,
        baseUrl: 'https://api.busmod.test',
        enableLogging: false,
        appName: 'Busmod',
      ),
    ).options;
    expect(o.followRedirects, isFalse);
    expect(o.validateStatus(200), isTrue);
    expect(o.validateStatus(299), isTrue);
    expect(o.validateStatus(302), isFalse);
    expect(o.validateStatus(null), isFalse);
  });
}
