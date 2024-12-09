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
    
  BudgetEntry.copy(BudgetEntry entry):
    entryName = entry.entryName,
    price = LocalizedPrice.copy(entry.price),
    thread = entry.thread,
    entryType = entry.entryType,
    entryTime = entry.entryTime,
    id = entry.id;
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

  LocalizedPrice.copy(LocalizedPrice price):
    currency = price.currency,
    value = price.value;
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

  static final BudgetEntryType _defaultType = BudgetEntryType(name: "Generic", colorParam: Colors.grey.value);
  static final BudgetEntryType _foodType = BudgetEntryType(name: 'Food', iconDataParam: Icons.fastfood.codePoint, colorParam: Colors.orange.value); 
  static final BudgetEntryType _transportType = BudgetEntryType(name: 'Transport', iconDataParam: Icons.train.codePoint, colorParam: Colors.green.value);
  static final BudgetEntryType _entertainmentType = BudgetEntryType(name: 'Entertainment', iconDataParam: Icons.tv.codePoint, colorParam: Colors.amber.value); 
  static final BudgetEntryType _shoppingType = BudgetEntryType(name: 'Shopping', iconDataParam: Icons.shopping_bag.codePoint, colorParam: Colors.red.value);
  factory BudgetEntryType.defaultType() => _defaultType;
  factory BudgetEntryType.foodType() => _foodType;
  factory BudgetEntryType.transportType() => _transportType;
  factory BudgetEntryType.entertainmentType() => _entertainmentType;
  factory BudgetEntryType.shoppingType() => _shoppingType;

  @ignore
  IconData get icon => IconData(iconData, fontFamily: "MaterialIcons");

  @ignore
  Color get color => Color(colorInt).withOpacity(1.0);
}

enum Currency with ProjectEnum{
  hkd,
  jpy, 
  usd,
  thb,
  rmb,
  ntw,
  euro;

  @override
  String get displayName => name.toUpperCase();

  static Currency? fromText(String cur) {
    for (var v in Currency.values) {
      if (v.name == cur.toLowerCase()) return v;
    }
    return null;
  } 

  static List<String> availableCurrency() {
    return Currency.values.map((v) => v.displayName).toList(); 
  }
}

mixin ProjectEnum on Enum{
  String get displayName => name;
}