// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kv_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKvEntryCollection on Isar {
  IsarCollection<KvEntry> get kvEntrys => this.collection();
}

const KvEntrySchema = CollectionSchema(
  name: r'KvEntry',
  id: -6622422974193289826,
  properties: {
    r'box': PropertySchema(id: 0, name: r'box', type: IsarType.string),
    r'key': PropertySchema(id: 1, name: r'key', type: IsarType.string),
    r'value': PropertySchema(id: 2, name: r'value', type: IsarType.string),
  },

  estimateSize: _kvEntryEstimateSize,
  serialize: _kvEntrySerialize,
  deserialize: _kvEntryDeserialize,
  deserializeProp: _kvEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'box_key': IndexSchema(
      id: 8383152221223212138,
      name: r'box_key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'box',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _kvEntryGetId,
  getLinks: _kvEntryGetLinks,
  attach: _kvEntryAttach,
  version: '3.3.2',
);

int _kvEntryEstimateSize(
  KvEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.box.length * 3;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _kvEntrySerialize(
  KvEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.box);
  writer.writeString(offsets[1], object.key);
  writer.writeString(offsets[2], object.value);
}

KvEntry _kvEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KvEntry();
  object.box = reader.readString(offsets[0]);
  object.id = id;
  object.key = reader.readString(offsets[1]);
  object.value = reader.readString(offsets[2]);
  return object;
}

P _kvEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _kvEntryGetId(KvEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _kvEntryGetLinks(KvEntry object) {
  return [];
}

void _kvEntryAttach(IsarCollection<dynamic> col, Id id, KvEntry object) {
  object.id = id;
}

extension KvEntryByIndex on IsarCollection<KvEntry> {
  Future<KvEntry?> getByBoxKey(String box, String key) {
    return getByIndex(r'box_key', [box, key]);
  }

  KvEntry? getByBoxKeySync(String box, String key) {
    return getByIndexSync(r'box_key', [box, key]);
  }

  Future<bool> deleteByBoxKey(String box, String key) {
    return deleteByIndex(r'box_key', [box, key]);
  }

  bool deleteByBoxKeySync(String box, String key) {
    return deleteByIndexSync(r'box_key', [box, key]);
  }

  Future<List<KvEntry?>> getAllByBoxKey(
    List<String> boxValues,
    List<String> keyValues,
  ) {
    final len = boxValues.length;
    assert(
      keyValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([boxValues[i], keyValues[i]]);
    }

    return getAllByIndex(r'box_key', values);
  }

  List<KvEntry?> getAllByBoxKeySync(
    List<String> boxValues,
    List<String> keyValues,
  ) {
    final len = boxValues.length;
    assert(
      keyValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([boxValues[i], keyValues[i]]);
    }

    return getAllByIndexSync(r'box_key', values);
  }

  Future<int> deleteAllByBoxKey(
    List<String> boxValues,
    List<String> keyValues,
  ) {
    final len = boxValues.length;
    assert(
      keyValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([boxValues[i], keyValues[i]]);
    }

    return deleteAllByIndex(r'box_key', values);
  }

  int deleteAllByBoxKeySync(List<String> boxValues, List<String> keyValues) {
    final len = boxValues.length;
    assert(
      keyValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([boxValues[i], keyValues[i]]);
    }

    return deleteAllByIndexSync(r'box_key', values);
  }

  Future<Id> putByBoxKey(KvEntry object) {
    return putByIndex(r'box_key', object);
  }

  Id putByBoxKeySync(KvEntry object, {bool saveLinks = true}) {
    return putByIndexSync(r'box_key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBoxKey(List<KvEntry> objects) {
    return putAllByIndex(r'box_key', objects);
  }

  List<Id> putAllByBoxKeySync(List<KvEntry> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'box_key', objects, saveLinks: saveLinks);
  }
}

extension KvEntryQueryWhereSort on QueryBuilder<KvEntry, KvEntry, QWhere> {
  QueryBuilder<KvEntry, KvEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KvEntryQueryWhere on QueryBuilder<KvEntry, KvEntry, QWhereClause> {
  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> boxEqualToAnyKey(
    String box,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'box_key', value: [box]),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> boxNotEqualToAnyKey(
    String box,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [],
                upper: [box],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [box],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [box],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [],
                upper: [box],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> boxKeyEqualTo(
    String box,
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'box_key', value: [box, key]),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterWhereClause> boxEqualToKeyNotEqualTo(
    String box,
    String key,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [box],
                upper: [box, key],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [box, key],
                includeLower: false,
                upper: [box],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [box, key],
                includeLower: false,
                upper: [box],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'box_key',
                lower: [box],
                upper: [box, key],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension KvEntryQueryFilter
    on QueryBuilder<KvEntry, KvEntry, QFilterCondition> {
  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'box',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'box',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'box',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'box',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'box',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'box',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'box',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'box',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'box', value: ''),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> boxIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'box', value: ''),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'value',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: ''),
      );
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterFilterCondition> valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'value', value: ''),
      );
    });
  }
}

extension KvEntryQueryObject
    on QueryBuilder<KvEntry, KvEntry, QFilterCondition> {}

extension KvEntryQueryLinks
    on QueryBuilder<KvEntry, KvEntry, QFilterCondition> {}

extension KvEntryQuerySortBy on QueryBuilder<KvEntry, KvEntry, QSortBy> {
  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> sortByBox() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'box', Sort.asc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> sortByBoxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'box', Sort.desc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension KvEntryQuerySortThenBy
    on QueryBuilder<KvEntry, KvEntry, QSortThenBy> {
  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenByBox() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'box', Sort.asc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenByBoxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'box', Sort.desc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension KvEntryQueryWhereDistinct
    on QueryBuilder<KvEntry, KvEntry, QDistinct> {
  QueryBuilder<KvEntry, KvEntry, QDistinct> distinctByBox({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'box', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KvEntry, KvEntry, QDistinct> distinctByValue({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension KvEntryQueryProperty
    on QueryBuilder<KvEntry, KvEntry, QQueryProperty> {
  QueryBuilder<KvEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KvEntry, String, QQueryOperations> boxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'box');
    });
  }

  QueryBuilder<KvEntry, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<KvEntry, String, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
