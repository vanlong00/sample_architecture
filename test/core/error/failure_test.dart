import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/error/failure.dart';

void main() {
  test('Failure union phân biệt được các nhánh qua when', () {
    const f = Failure.server(message: 'boom', code: 500);
    final label = f.when(
      server: (m, c) => 'server:$m:$c',
      network: () => 'network',
      cache: () => 'cache',
      unauthorized: () => 'unauthorized',
      unknown: (m) => 'unknown',
    );
    expect(label, 'server:boom:500');
  });

  test('hai Failure cùng loại + giá trị thì bằng nhau', () {
    expect(const Failure.network(), const Failure.network());
  });
}
