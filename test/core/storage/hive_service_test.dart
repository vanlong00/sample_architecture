import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sample_architecture/core/storage/hive_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Hive.init('./.dart_tool/hive_test');
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  test('write rồi read trả lại đúng giá trị', () async {
    final svc = HiveService();
    await svc.openBox(HiveBoxes.settings);
    await svc.write<String>(HiveBoxes.settings, 'themeMode', 'dark');
    expect(svc.read<String>(HiveBoxes.settings, 'themeMode'), 'dark');
  });

  test('read key chưa tồn tại trả null', () async {
    final svc = HiveService();
    await svc.openBox(HiveBoxes.settings);
    expect(svc.read<String>(HiveBoxes.settings, 'missing'), isNull);
  });
}
