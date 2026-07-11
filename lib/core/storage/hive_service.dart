import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const String settings = 'settings';
  static const String cache = 'cache';
}

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    await openBox(HiveBoxes.settings);
    await openBox(HiveBoxes.cache);
  }

  Future<void> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<dynamic>(boxName);
    }
  }

  T? read<T>(String boxName, String key) {
    return Hive.box<dynamic>(boxName).get(key) as T?;
  }

  Future<void> write<T>(String boxName, String key, T value) {
    return Hive.box<dynamic>(boxName).put(key, value);
  }
}
