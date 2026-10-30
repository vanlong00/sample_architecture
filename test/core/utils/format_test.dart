import 'package:busmod/core/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatBytes', () {
    const table = {
      0: '0 B',
      1023: '1023 B',
      1024: '1.0 KB',
      1536: '1.5 KB',
      1048576: '1.0 MB',
      5 * 1048576 + 262144: '5.3 MB',
      1073741824: '1.0 GB',
      5 * 1073741824: '5.0 GB',
      2048 * 1073741824: '2048.0 GB',
    };
    table.forEach((bytes, text) => expect(formatBytes(bytes), text));
  });
}
