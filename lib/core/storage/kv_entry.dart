import 'package:isar_community/isar.dart';

part 'kv_entry.g.dart';

/// One key-value row, in a single collection for the whole app.
///
/// Everything goes through the `LocalStore` facade with a `(box, key) -> value`
/// signature, and values are self-describing JSON strings, so one shared
/// collection is enough (no per-type schemas).
@collection
class KvEntry {
  Id id = Isar.autoIncrement;

  /// Key namespace. The composite index is `unique` with `replace`, so
  /// `putByBoxKey` is an upsert.
  @Index(composite: [CompositeIndex('key')], unique: true, replace: true)
  late String box;

  late String key;

  /// The value after `jsonEncode`. The raw type is never stored directly, so
  /// `read<bool>` / `read<int>` / `read<List>` decode to the right type.
  late String value;
}
