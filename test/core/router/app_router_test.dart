import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/core/router/routes.dart';

void main() {
  test('route articles là "/"', () {
    expect(Routes.articles, '/');
  });
}
