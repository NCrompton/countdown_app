// import 'package:calendar/utils/const.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:math';

// class BudgetThread {
//   String threadName;
//   Currency preferredCurrency;
//   /// sorted by entryTime in ascending order 
//   final List<BudgetEntry> budgets; 
//   set budgets(List<BudgetEntry> budgets) {
//     this.budgets = budgets;
//     budgets.sort((a, b) => a.entryTime.compareTo(b.entryTime));
//   }

//   BudgetThread({
//     required this.threadName,
//     Currency? preferredCurrency,
//     this.budgets = const [],
//   }): preferredCurrency = preferredCurrency ?? Currency.hkd;
// }

// class BudgetEntry {
//   String id;
//   String entryName;
//   LocalizedPrice price;
//   BudgetEntryType entryType;
//   DateTime entryTime;

//   BudgetEntry({
//     String? id, 
//     required this.entryName,
//     required this.price,
//     BudgetEntryType? entryType,
//     DateTime? entryTime,
//   }): id = id ?? const Uuid().v4(), entryTime = entryTime ?? DateTime.now(), entryType = entryType ?? BudgetEntryType.defaultType();
// }

// class LocalizedPrice {
//   Currency currency;
//   double value;

//   LocalizedPrice({
//     required this.value,
//     Currency? currency
//   }): currency = currency ?? Currency.fromText(defaultCurrency)!;
// }

// class BudgetEntryType {
//   String typeName;
//   IconData icon;
//   Color color;

//   BudgetEntryType({
//     required this.typeName,
//     IconData? icon,
//     Color? color,
//   }): icon = icon ?? Icons.attach_money, color = color ?? Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
// ;

//   static final BudgetEntryType _defaultType = BudgetEntryType(typeName: "Generic");
//   factory BudgetEntryType.defaultType() => _defaultType;
// }

// enum Currency {
//   hkd,
//   jpy, 
//   euro;

//   static Currency? fromText(String cur) {
//     for (var v in Currency.values) {
//       if (v.name == cur.toLowerCase()) return v;
//     }
//     return null;
//   } 

//   static List<String> availableCurrency() {
//     return Currency.values.map((v) => v.name).toList(); 
//   }
// }