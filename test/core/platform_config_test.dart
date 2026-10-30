// Release hardening that lives outside Dart: the MAIN Android network
// security config must forbid cleartext; only the dev flavor may allow it.
import 'dart:io';

import 'package:busmod/core/ads/ad_network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String read(String path) => File(path).readAsStringSync();

  test('main network_security_config forbids cleartext everywhere', () {
    final xml = read(
      'android/app/src/main/res/xml/network_security_config.xml',
    );
    expect(xml, contains('<base-config cleartextTrafficPermitted="false"'));
    expect(xml, isNot(contains('cleartextTrafficPermitted="true"')));
    expect(xml, isNot(contains('<domain-config')));
  });

  test('the manifest actually points at that config and does not re-enable '
      'cleartext', () {
    final manifest = read('android/app/src/main/AndroidManifest.xml');
    expect(
      manifest,
      contains('android:networkSecurityConfig="@xml/network_security_config"'),
    );
    expect(manifest, isNot(contains('usesCleartextTraffic="true"')));
  });

  test('only the dev flavor overrides it to allow cleartext', () {
    final dev = read('android/app/src/dev/res/xml/network_security_config.xml');
    expect(dev, contains('cleartextTrafficPermitted="true"'));
    for (final flavor in ['staging', 'prod', 'release', 'profile']) {
      final f = File(
        'android/app/src/$flavor/res/xml/network_security_config.xml',
      );
      if (f.existsSync()) {
        expect(f.readAsStringSync(), isNot(contains('"true"')), reason: flavor);
      }
    }
  });

  test('the ad country lookup uses https (main config blocks http)', () {
    expect(AdCountryLookup.url, startsWith('https://'));
  });
}
