import 'package:mason/mason.dart';

void run(HookContext context) {
  final featureName = context.vars['feature_name'];
  context.logger.info('''
✅ Feature "$featureName" đã được tạo.

Việc còn lại (thủ công):
1. Thêm route path vào lib/core/router/routes.dart
2. Thêm GoRoute cho ${featureName}Page vào lib/core/router/app_router.dart
3. Chạy: flutter pub run build_runner build --delete-conflicting-outputs
4. Chạy: flutter test test/features/$featureName
''');
}
