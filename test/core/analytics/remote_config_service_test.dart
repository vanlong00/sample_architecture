import 'package:busmod/core/ads/more_app.dart';
import 'package:busmod/core/analytics/remote_config_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = RemoteConfigService();

  test('defaults map', () {
    expect(RemoteConfigService.defaults, {
      'force_update': false,
      'min_supported_version': '1.0.0',
      'ads_enabled': true,
      'max_ad_requests': 3,
      'more_apps': '[]',
      'native_max_impressions': 3,
      'native_max_age_minutes': 30,
      'native_list_ads_enabled': true,
    });
  });

  test('typed getters read defaults', () {
    expect(service.getBool(RemoteConfigKeys.adsEnabled), isTrue);
    expect(service.getBool(RemoteConfigKeys.forceUpdate), isFalse);
    expect(service.getInt(RemoteConfigKeys.maxAdRequests), 3);
    expect(service.getString(RemoteConfigKeys.minSupportedVersion), '1.0.0');
  });

  test('unknown key and type mismatch give zero values', () {
    expect(service.getBool('nope'), isFalse);
    expect(service.getInt('nope'), 0);
    expect(service.getString('nope'), '');
    expect(service.getInt(RemoteConfigKeys.adsEnabled), 0);
  });

  test('getMoreApps is empty for default []', () {
    expect(service.getMoreApps(), isEmpty);
  });

  group('parseMoreApps', () {
    final parse = RemoteConfigService.parseMoreApps;

    test('valid list', () {
      final apps = parse('[{"name":"A","packageName":"io.a"},{"name":"B"}]');
      expect(apps.map((a) => a.name), ['A', 'B']);
      expect(apps.first.packageName, 'io.a');
    });

    test('skips non-object items', () {
      expect(parse('[1,"x",{"name":"A"}]').single.name, 'A');
    });

    test('malformed JSON, non-list and empty fail open', () {
      expect(parse('{oops'), isEmpty);
      expect(parse('{"name":"A"}'), isEmpty);
      expect(parse(''), isEmpty);
    });
  });

  group('MoreApp.fromJson', () {
    test('parses a valid list entry', () {
      final app = MoreApp.fromJson({
        'name': 'A',
        'icon': 'i',
        'packageName': 'io.a',
        'appStoreId': '1',
      });
      expect(app.name, 'A');
      expect(app.icon, 'i');
      expect(app.packageName, 'io.a');
      expect(app.appStoreId, '1');
      expect(app.banner, '');
    });

    test('wrong types fall back to defaults', () {
      final app = MoreApp.fromJson({'name': 5, 'appStoreId': 1});
      expect(app.name, '');
      expect(app.appStoreId, isNull);
    });
  });
}
