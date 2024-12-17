// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_schema.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetThreadCollection on Isar {
  IsarCollection<BudgetThread> get budgetThreads => this.collection();
}

const BudgetThreadSchema = CollectionSchema(
  name: r'BudgetThread',
  id: 8515677963265199081,
  properties: {
    r'enabled': PropertySchema(
      id: 0,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'preferredCurrency': PropertySchema(
      id: 1,
      name: r'preferredCurrency',
      type: IsarType.string,
      enumMap: _BudgetThreadpreferredCurrencyEnumValueMap,
    ),
    r'threadName': PropertySchema(
      id: 2,
      name: r'threadName',
      type: IsarType.string,
    )
  },
  estimateSize: _budgetThreadEstimateSize,
  serialize: _budgetThreadSerialize,
  deserialize: _budgetThreadDeserialize,
  deserializeProp: _budgetThreadDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'budgets': LinkSchema(
      id: 6851707646187725856,
      name: r'budgets',
      target: r'BudgetEntry',
      single: false,
      linkName: r'thread',
    )
  },
  embeddedSchemas: {},
  getId: _budgetThreadGetId,
  getLinks: _budgetThreadGetLinks,
  attach: _budgetThreadAttach,
  version: '3.1.0+1',
);

int _budgetThreadEstimateSize(
  BudgetThread object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.preferredCurrency.name.length * 3;
  bytesCount += 3 + object.threadName.length * 3;
  return bytesCount;
}

void _budgetThreadSerialize(
  BudgetThread object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeString(offsets[1], object.preferredCurrency.name);
  writer.writeString(offsets[2], object.threadName);
}

BudgetThread _budgetThreadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetThread(
    preferredCurrency: _BudgetThreadpreferredCurrencyValueEnumMap[
            reader.readStringOrNull(offsets[1])] ??
        Currency.hkd,
    threadName: reader.readString(offsets[2]),
  );
  object.enabled = reader.readBool(offsets[0]);
  object.id = id;
  return object;
}

P _budgetThreadDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (_BudgetThreadpreferredCurrencyValueEnumMap[
              reader.readStringOrNull(offset)] ??
          Currency.hkd) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BudgetThreadpreferredCurrencyEnumValueMap = {
  r'hkd': r'hkd',
  r'jpy': r'jpy',
  r'usd': r'usd',
  r'thb': r'thb',
  r'rmb': r'rmb',
  r'ntw': r'ntw',
  r'euro': r'euro',
};
const _BudgetThreadpreferredCurrencyValueEnumMap = {
  r'hkd': Currency.hkd,
  r'jpy': Currency.jpy,
  r'usd': Currency.usd,
  r'thb': Currency.thb,
  r'rmb': Currency.rmb,
  r'ntw': Currency.ntw,
  r'euro': Currency.euro,
};

Id _budgetThreadGetId(BudgetThread object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetThreadGetLinks(BudgetThread object) {
  return [object.budgets];
}

void _budgetThreadAttach(
    IsarCollection<dynamic> col, Id id, BudgetThread object) {
  object.id = id;
  object.budgets
      .attach(col, col.isar.collection<BudgetEntry>(), r'budgets', id);
}

extension BudgetThreadQueryWhereSort
    on QueryBuilder<BudgetThread, BudgetThread, QWhere> {
  QueryBuilder<BudgetThread, BudgetThread, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetThreadQueryWhere
    on QueryBuilder<BudgetThread, BudgetThread, QWhereClause> {
  QueryBuilder<BudgetThread, BudgetThread, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<BudgetThread, BudgetThread, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetThreadQueryFilter
    on QueryBuilder<BudgetThread, BudgetThread, QFilterCondition> {
  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyEqualTo(
    Currency value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredCurrency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyGreaterThan(
    Currency value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preferredCurrency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyLessThan(
    Currency value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preferredCurrency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyBetween(
    Currency lower,
    Currency upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preferredCurrency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preferredCurrency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preferredCurrency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preferredCurrency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preferredCurrency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredCurrency',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      preferredCurrencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preferredCurrency',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'threadName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'threadName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'threadName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'threadName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'threadName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'threadName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'threadName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'threadName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'threadName',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      threadNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'threadName',
        value: '',
      ));
    });
  }
}

extension BudgetThreadQueryObject
    on QueryBuilder<BudgetThread, BudgetThread, QFilterCondition> {}

extension BudgetThreadQueryLinks
    on QueryBuilder<BudgetThread, BudgetThread, QFilterCondition> {
  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition> budgets(
      FilterQuery<BudgetEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'budgets');
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      budgetsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'budgets', length, true, length, true);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      budgetsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'budgets', 0, true, 0, true);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      budgetsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'budgets', 0, false, 999999, true);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      budgetsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'budgets', 0, true, length, include);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      budgetsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'budgets', length, include, 999999, true);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterFilterCondition>
      budgetsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'budgets', lower, includeLower, upper, includeUpper);
    });
  }
}

extension BudgetThreadQuerySortBy
    on QueryBuilder<BudgetThread, BudgetThread, QSortBy> {
  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy>
      sortByPreferredCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredCurrency', Sort.asc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy>
      sortByPreferredCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredCurrency', Sort.desc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> sortByThreadName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadName', Sort.asc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy>
      sortByThreadNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadName', Sort.desc);
    });
  }
}

extension BudgetThreadQuerySortThenBy
    on QueryBuilder<BudgetThread, BudgetThread, QSortThenBy> {
  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy>
      thenByPreferredCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredCurrency', Sort.asc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy>
      thenByPreferredCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredCurrency', Sort.desc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy> thenByThreadName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadName', Sort.asc);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QAfterSortBy>
      thenByThreadNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadName', Sort.desc);
    });
  }
}

extension BudgetThreadQueryWhereDistinct
    on QueryBuilder<BudgetThread, BudgetThread, QDistinct> {
  QueryBuilder<BudgetThread, BudgetThread, QDistinct> distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QDistinct>
      distinctByPreferredCurrency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preferredCurrency',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BudgetThread, BudgetThread, QDistinct> distinctByThreadName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'threadName', caseSensitive: caseSensitive);
    });
  }
}

extension BudgetThreadQueryProperty
    on QueryBuilder<BudgetThread, BudgetThread, QQueryProperty> {
  QueryBuilder<BudgetThread, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetThread, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<BudgetThread, Currency, QQueryOperations>
      preferredCurrencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredCurrency');
    });
  }

  QueryBuilder<BudgetThread, String, QQueryOperations> threadNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'threadName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetEntryCollection on Isar {
  IsarCollection<BudgetEntry> get budgetEntrys => this.collection();
}

const BudgetEntrySchema = CollectionSchema(
  name: r'BudgetEntry',
  id: 4168342879795991231,
  properties: {
    r'enabled': PropertySchema(
      id: 0,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'entryName': PropertySchema(
      id: 1,
      name: r'entryName',
      type: IsarType.string,
    ),
    r'entryTime': PropertySchema(
      id: 2,
      name: r'entryTime',
      type: IsarType.dateTime,
    ),
    r'entryType': PropertySchema(
      id: 3,
      name: r'entryType',
      type: IsarType.long,
    ),
    r'price': PropertySchema(
      id: 4,
      name: r'price',
      type: IsarType.object,
      target: r'LocalizedPrice',
    )
  },
  estimateSize: _budgetEntryEstimateSize,
  serialize: _budgetEntrySerialize,
  deserialize: _budgetEntryDeserialize,
  deserializeProp: _budgetEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'thread': LinkSchema(
      id: -6475078827683196957,
      name: r'thread',
      target: r'BudgetThread',
      single: true,
    )
  },
  embeddedSchemas: {r'LocalizedPrice': LocalizedPriceSchema},
  getId: _budgetEntryGetId,
  getLinks: _budgetEntryGetLinks,
  attach: _budgetEntryAttach,
  version: '3.1.0+1',
);

int _budgetEntryEstimateSize(
  BudgetEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entryName.length * 3;
  bytesCount += 3 +
      LocalizedPriceSchema.estimateSize(
          object.price, allOffsets[LocalizedPrice]!, allOffsets);
  return bytesCount;
}

void _budgetEntrySerialize(
  BudgetEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeString(offsets[1], object.entryName);
  writer.writeDateTime(offsets[2], object.entryTime);
  writer.writeLong(offsets[3], object.entryType);
  writer.writeObject<LocalizedPrice>(
    offsets[4],
    allOffsets,
    LocalizedPriceSchema.serialize,
    object.price,
  );
}

BudgetEntry _budgetEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetEntry(
    entryName: reader.readString(offsets[1]),
    price: reader.readObjectOrNull<LocalizedPrice>(
          offsets[4],
          LocalizedPriceSchema.deserialize,
          allOffsets,
        ) ??
        LocalizedPrice(),
  );
  object.enabled = reader.readBool(offsets[0]);
  object.entryTime = reader.readDateTime(offsets[2]);
  object.entryType = reader.readLong(offsets[3]);
  object.id = id;
  return object;
}

P _budgetEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readObjectOrNull<LocalizedPrice>(
            offset,
            LocalizedPriceSchema.deserialize,
            allOffsets,
          ) ??
          LocalizedPrice()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetEntryGetId(BudgetEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetEntryGetLinks(BudgetEntry object) {
  return [object.thread];
}

void _budgetEntryAttach(
    IsarCollection<dynamic> col, Id id, BudgetEntry object) {
  object.id = id;
  object.thread.attach(col, col.isar.collection<BudgetThread>(), r'thread', id);
}

extension BudgetEntryQueryWhereSort
    on QueryBuilder<BudgetEntry, BudgetEntry, QWhere> {
  QueryBuilder<BudgetEntry, BudgetEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetEntryQueryWhere
    on QueryBuilder<BudgetEntry, BudgetEntry, QWhereClause> {
  QueryBuilder<BudgetEntry, BudgetEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetEntryQueryFilter
    on QueryBuilder<BudgetEntry, BudgetEntry, QFilterCondition> {
  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> enabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entryName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryName',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entryName',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryType',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryType',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryType',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition>
      entryTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetEntryQueryObject
    on QueryBuilder<BudgetEntry, BudgetEntry, QFilterCondition> {
  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> price(
      FilterQuery<LocalizedPrice> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'price');
    });
  }
}

extension BudgetEntryQueryLinks
    on QueryBuilder<BudgetEntry, BudgetEntry, QFilterCondition> {
  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> thread(
      FilterQuery<BudgetThread> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'thread');
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterFilterCondition> threadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'thread', 0, true, 0, true);
    });
  }
}

extension BudgetEntryQuerySortBy
    on QueryBuilder<BudgetEntry, BudgetEntry, QSortBy> {
  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEntryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryName', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEntryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryName', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEntryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTime', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEntryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTime', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEntryType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryType', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> sortByEntryTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryType', Sort.desc);
    });
  }
}

extension BudgetEntryQuerySortThenBy
    on QueryBuilder<BudgetEntry, BudgetEntry, QSortThenBy> {
  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEntryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryName', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEntryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryName', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEntryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTime', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEntryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTime', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEntryType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryType', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByEntryTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryType', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension BudgetEntryQueryWhereDistinct
    on QueryBuilder<BudgetEntry, BudgetEntry, QDistinct> {
  QueryBuilder<BudgetEntry, BudgetEntry, QDistinct> distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QDistinct> distinctByEntryName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QDistinct> distinctByEntryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryTime');
    });
  }

  QueryBuilder<BudgetEntry, BudgetEntry, QDistinct> distinctByEntryType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryType');
    });
  }
}

extension BudgetEntryQueryProperty
    on QueryBuilder<BudgetEntry, BudgetEntry, QQueryProperty> {
  QueryBuilder<BudgetEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetEntry, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<BudgetEntry, String, QQueryOperations> entryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryName');
    });
  }

  QueryBuilder<BudgetEntry, DateTime, QQueryOperations> entryTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryTime');
    });
  }

  QueryBuilder<BudgetEntry, int, QQueryOperations> entryTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryType');
    });
  }

  QueryBuilder<BudgetEntry, LocalizedPrice, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetEntryTypeCollection on Isar {
  IsarCollection<BudgetEntryType> get budgetEntryTypes => this.collection();
}

const BudgetEntryTypeSchema = CollectionSchema(
  name: r'BudgetEntryType',
  id: 8341813099737392729,
  properties: {
    r'colorInt': PropertySchema(
      id: 0,
      name: r'colorInt',
      type: IsarType.long,
    ),
    r'iconData': PropertySchema(
      id: 1,
      name: r'iconData',
      type: IsarType.long,
    ),
    r'typeName': PropertySchema(
      id: 2,
      name: r'typeName',
      type: IsarType.string,
    )
  },
  estimateSize: _budgetEntryTypeEstimateSize,
  serialize: _budgetEntryTypeSerialize,
  deserialize: _budgetEntryTypeDeserialize,
  deserializeProp: _budgetEntryTypeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _budgetEntryTypeGetId,
  getLinks: _budgetEntryTypeGetLinks,
  attach: _budgetEntryTypeAttach,
  version: '3.1.0+1',
);

int _budgetEntryTypeEstimateSize(
  BudgetEntryType object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.typeName.length * 3;
  return bytesCount;
}

void _budgetEntryTypeSerialize(
  BudgetEntryType object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.colorInt);
  writer.writeLong(offsets[1], object.iconData);
  writer.writeString(offsets[2], object.typeName);
}

BudgetEntryType _budgetEntryTypeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetEntryType();
  object.colorInt = reader.readLong(offsets[0]);
  object.iconData = reader.readLong(offsets[1]);
  object.id = id;
  object.typeName = reader.readString(offsets[2]);
  return object;
}

P _budgetEntryTypeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetEntryTypeGetId(BudgetEntryType object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetEntryTypeGetLinks(BudgetEntryType object) {
  return [];
}

void _budgetEntryTypeAttach(
    IsarCollection<dynamic> col, Id id, BudgetEntryType object) {
  object.id = id;
}

extension BudgetEntryTypeQueryWhereSort
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QWhere> {
  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetEntryTypeQueryWhere
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QWhereClause> {
  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetEntryTypeQueryFilter
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QFilterCondition> {
  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      colorIntEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      colorIntGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      colorIntLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      colorIntBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorInt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      iconDataEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconData',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      iconDataGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconData',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      iconDataLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconData',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      iconDataBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeName',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterFilterCondition>
      typeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeName',
        value: '',
      ));
    });
  }
}

extension BudgetEntryTypeQueryObject
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QFilterCondition> {}

extension BudgetEntryTypeQueryLinks
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QFilterCondition> {}

extension BudgetEntryTypeQuerySortBy
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QSortBy> {
  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      sortByColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInt', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      sortByColorIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInt', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      sortByIconData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconData', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      sortByIconDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconData', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      sortByTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      sortByTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.desc);
    });
  }
}

extension BudgetEntryTypeQuerySortThenBy
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QSortThenBy> {
  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      thenByColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInt', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      thenByColorIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorInt', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      thenByIconData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconData', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      thenByIconDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconData', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      thenByTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.asc);
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QAfterSortBy>
      thenByTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeName', Sort.desc);
    });
  }
}

extension BudgetEntryTypeQueryWhereDistinct
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QDistinct> {
  QueryBuilder<BudgetEntryType, BudgetEntryType, QDistinct>
      distinctByColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorInt');
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QDistinct>
      distinctByIconData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconData');
    });
  }

  QueryBuilder<BudgetEntryType, BudgetEntryType, QDistinct> distinctByTypeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeName', caseSensitive: caseSensitive);
    });
  }
}

extension BudgetEntryTypeQueryProperty
    on QueryBuilder<BudgetEntryType, BudgetEntryType, QQueryProperty> {
  QueryBuilder<BudgetEntryType, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetEntryType, int, QQueryOperations> colorIntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorInt');
    });
  }

  QueryBuilder<BudgetEntryType, int, QQueryOperations> iconDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconData');
    });
  }

  QueryBuilder<BudgetEntryType, String, QQueryOperations> typeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeName');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocalizedPriceSchema = Schema(
  name: r'LocalizedPrice',
  id: 6941168485080762309,
  properties: {
    r'currency': PropertySchema(
      id: 0,
      name: r'currency',
      type: IsarType.string,
      enumMap: _LocalizedPricecurrencyEnumValueMap,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.double,
    )
  },
  estimateSize: _localizedPriceEstimateSize,
  serialize: _localizedPriceSerialize,
  deserialize: _localizedPriceDeserialize,
  deserializeProp: _localizedPriceDeserializeProp,
);

int _localizedPriceEstimateSize(
  LocalizedPrice object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.name.length * 3;
  return bytesCount;
}

void _localizedPriceSerialize(
  LocalizedPrice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currency.name);
  writer.writeDouble(offsets[1], object.value);
}

LocalizedPrice _localizedPriceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalizedPrice();
  object.currency = _LocalizedPricecurrencyValueEnumMap[
          reader.readStringOrNull(offsets[0])] ??
      Currency.hkd;
  object.value = reader.readDouble(offsets[1]);
  return object;
}

P _localizedPriceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_LocalizedPricecurrencyValueEnumMap[
              reader.readStringOrNull(offset)] ??
          Currency.hkd) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LocalizedPricecurrencyEnumValueMap = {
  r'hkd': r'hkd',
  r'jpy': r'jpy',
  r'usd': r'usd',
  r'thb': r'thb',
  r'rmb': r'rmb',
  r'ntw': r'ntw',
  r'euro': r'euro',
};
const _LocalizedPricecurrencyValueEnumMap = {
  r'hkd': Currency.hkd,
  r'jpy': Currency.jpy,
  r'usd': Currency.usd,
  r'thb': Currency.thb,
  r'rmb': Currency.rmb,
  r'ntw': Currency.ntw,
  r'euro': Currency.euro,
};

extension LocalizedPriceQueryFilter
    on QueryBuilder<LocalizedPrice, LocalizedPrice, QFilterCondition> {
  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyEqualTo(
    Currency value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyGreaterThan(
    Currency value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyLessThan(
    Currency value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyBetween(
    Currency lower,
    Currency upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalizedPrice, LocalizedPrice, QAfterFilterCondition>
      valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension LocalizedPriceQueryObject
    on QueryBuilder<LocalizedPrice, LocalizedPrice, QFilterCondition> {}
