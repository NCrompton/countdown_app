import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
part 'budget_schema.g.dart';

@collection
class BudgetThread {
  Id id = Isar.autoIncrement;
  String threadName;

  @Enumerated(EnumType.name)
  Currency preferredCurrency;
  /// sorted by entryTime in ascending order 
  @Backlink(to: 'thread')
  IsarLinks<BudgetEntry> budgets = IsarLinks<BudgetEntry>(); 

  BudgetThread({
    required this.threadName,
    required this.preferredCurrency,
    IsarLinks<BudgetEntry>? budgets
  }): budgets = budgets ?? IsarLinks<BudgetEntry>();
}

@collection
class BudgetEntry {
  Id id = Isar.autoIncrement;
  String entryName;
  LocalizedPrice price;
  BudgetEntryType entryType;
  DateTime entryTime;
  IsarLink<BudgetThread> thread = IsarLink<BudgetThread>();

  BudgetEntry({
    required this.entryName,
    required this.price,
    BudgetThread? threadParam,
    BudgetEntryType? type,
    DateTime? time,
  }):
    entryTime = time ?? DateTime.now(), 
    entryType = type ?? BudgetEntryType._defaultType,
    thread = IsarLink<BudgetThread>()..value = threadParam;
}

@embedded
class LocalizedPrice {
  @Enumerated(EnumType.name)
  Currency currency;
  double value;

  LocalizedPrice({
    double? valueParam,
    Currency? currencyParam
  }): value = valueParam ?? 0, currency = currencyParam ?? Currency.hkd;
}

@embedded
class BudgetEntryType {
  String typeName;
  int iconData;
  int colorInt;

  BudgetEntryType({
    String? name,
    int? iconDataParam,
    int? colorParam,
  }): typeName = name ?? "", 
    iconData = iconDataParam ?? Icons.accessibility.codePoint, 
    colorInt = colorParam ?? (Random().nextDouble() * 0xFFFFFF).toInt();

  static final BudgetEntryType _defaultType = BudgetEntryType(name: "Generic");
  factory BudgetEntryType.defaultType() => _defaultType;

  @ignore
  IconData get icon => IconData(iconData, fontFamily: "MaterialIcons");

  @ignore
  Color get color => Color(colorInt).withOpacity(1.0);
}

enum Currency {
  hkd,
  jpy, 
  euro;

  static Currency? fromText(String cur) {
    for (var v in Currency.values) {
      if (v.name == cur.toLowerCase()) return v;
    }
    return null;
  } 

  static List<String> availableCurrency() {
    return Currency.values.map((v) => v.name).toList(); 
  }
}