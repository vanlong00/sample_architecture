import 'package:flutter_test/flutter_test.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';

void main() {
  test('fromJson parse đúng các trường', () {
    final a = Article.fromJson(const {
      'id': 1,
      'title': 'Hello',
      'body': 'World',
    });
    expect(a.id, 1);
    expect(a.title, 'Hello');
    expect(a.body, 'World');
  });
}
