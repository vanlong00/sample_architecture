import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/features/{{feature_name.snakeCase()}}/data/models/{{entity_name.snakeCase()}}_model.dart';

void main() {
  test('fromJson parse đúng các trường', () {
    final item = {{entity_name.pascalCase()}}.fromJson(const {
      'id': 1,
      'name': 'Hello',
    });
    expect(item.id, 1);
    expect(item.name, 'Hello');
  });
}
