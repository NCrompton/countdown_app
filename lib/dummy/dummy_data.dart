import 'package:calendar/model/budget_model.dart';
import 'package:flutter/material.dart';

final dummyBudgetThread = [
    BudgetThread(threadName: "Test2", budgets: [
        BudgetEntry(entryName: "first2", price: LocalizedPrice(value: 2), entryType: BudgetEntryType(typeName: "Eat", icon: Icons.fastfood)),
        BudgetEntry(entryName: "second2", price: LocalizedPrice(value: -5000))
    ]),
    BudgetThread(threadName: "Test", budgets: [
        BudgetEntry(entryName: "first", price: LocalizedPrice(value: 2)),
        BudgetEntry(entryName: "second", price: LocalizedPrice(value: -5))
    ]),
    BudgetThread(threadName: "Test3", budgets: [
        BudgetEntry(entryName: "first3", price: LocalizedPrice(value: 200)),
        BudgetEntry(entryName: "second3", price: LocalizedPrice(value: 5000))
    ])
  ];