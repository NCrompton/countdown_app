import 'package:calendar/model/budget_schema.dart';
import 'package:flutter/material.dart';

// final dummyBudgetThread = [
//     BudgetThread(threadName: "Test2", preferredCurrency: Currency.hkd ,budgets: [
//         BudgetEntry(entryName: "first2", price: LocalizedPrice(valueParam: 2), entryType: BudgetEntryType(typeName: "Eat", iconData: Icons.fastfood.codePoint)),
//         BudgetEntry(entryName: "second2", price: LocalizedPrice(valueParam: -5000))
//     ]),
//     BudgetThread(threadName: "Test", preferredCurrency: Currency.jpy, budgets: [
//         BudgetEntry(entryName: "first", price: LocalizedPrice(valueParam: 2)),
//         BudgetEntry(entryName: "second", price: LocalizedPrice(valueParam: -5))
//     ]),
//     BudgetThread(threadName: "Test3", preferredCurrency: Currency.euro, budgets: [
//         BudgetEntry(entryName: "first3", price: LocalizedPrice(valueParam: 200)),
//         BudgetEntry(entryName: "second3", price: LocalizedPrice(valueParam: 5000))
//     ])
//   ];

final entry1 = BudgetEntry(entryName: "entry1", price: LocalizedPrice(valueParam: 12.3, currencyParam: Currency.hkd));
final entry2 = BudgetEntry(entryName: "entry2", price: LocalizedPrice(valueParam: 1.5, currencyParam: Currency.hkd));
final entry3 = BudgetEntry(entryName: "entry3", price: LocalizedPrice(valueParam: 45.6, currencyParam: Currency.jpy));

final thread1 = BudgetThread(threadName: "Test", preferredCurrency: Currency.hkd)..budgets.add(entry1)..budgets.add(entry2);
final thread2 = BudgetThread(threadName: "Test2", preferredCurrency: Currency.jpy)..budgets.add(entry3);
final thread3 = BudgetThread(threadName: "Test3", preferredCurrency: Currency.euro);

final List<BudgetThread> dummyBudgetThread = [thread1, thread2, thread3];

final List<BudgetEntryType> entryTypes = [
  BudgetEntryType.defaultType(), 
  BudgetEntryType(name: 'Food', iconDataParam: Icons.fastfood.codePoint), 
  BudgetEntryType(name: 'Transport', iconDataParam: Icons.train.codePoint), 
  BudgetEntryType(name: 'Entertainment', iconDataParam: Icons.tv.codePoint), 
  BudgetEntryType(name: 'Shopping', iconDataParam: Icons.shopping_bag.codePoint)
];