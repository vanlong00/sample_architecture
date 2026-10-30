import 'package:busmod/features/downloads/data/logic/mod_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fileExtensionOf', () {
    const table = <String, String?>{
      'https://cdn.x/mods/12.RAR': 'RAR',
      'https://cdn.x/mods/12.zip': 'zip',
      'https://cdn.x/mods/12.zip?token=a.b&x=1.rar': 'zip',
      'https://cdn.x/mods/12.zip#frag.rar': 'zip',
      'https://cdn.x/mods/12': null,
      'https://cdn.x/mods/12?x=1.zip': null,
      'https://cdn.x/dir.v1/12': null,
      'https://cdn.x/mods/my.mod.v2.Zip': 'Zip',
      'https://cdn.x/mods/12.': null,
      'https://cdn.x/': null,
      'https://cdn.x': null,
      'https://cdn.x/mods/12.z%2fp': null,
      '': null,
    };
    table.forEach((url, ext) {
      test('"$url" -> $ext', () => expect(fileExtensionOf(url), ext));
    });
  });

  group('isAllowedStorageUrl (F1)', () {
    for (final url in [
      'https://cdn.x/mods/12.zip?sig=1',
      'http://10.0.2.2/mods/12.rar',
      'https://cdn.x@cdn2.x/12.zip',
    ]) {
      test('allows $url', () => expect(isAllowedStorageUrl(url), isTrue));
    }
    for (final url in <String?>[
      null,
      '',
      'https://cdn.x/noext',
      'file:///sdcard/a.zip',
      'ftp://cdn.x/a.zip',
      'https://www.mediafire.com/file/a.zip',
      'https://f000.backblazeb2.com/file/a.zip',
      'https://backblaze.com/a.zip',
      'https://evil.com@www.mediafire.com/a.zip',
      'https://MEDIAFIRE.com./a.zip',
      'https:///a.zip',
      '/files/a.zip',
      'a.zip',
      'javascript:alert(1)//a.zip',
    ]) {
      test('rejects $url', () => expect(isAllowedStorageUrl(url), isFalse));
    }
  });

  test('modRelPath', () => expect(modRelPath(7, 'RAR'), 'mods/7.RAR'));

  test('importMimeFor lowercases and falls back', () {
    expect(importMimeFor('ZIP'), kImportMimeByExt['zip']);
    expect(importMimeFor('Rar'), kImportMimeByExt['rar']);
    expect(importMimeFor('7z'), '*/*');
  });
}
