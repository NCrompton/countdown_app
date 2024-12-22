import 'package:calendar/model/budget_schema.dart';

// final dummyBudgetThread = [
//     BudgetThread(threadName: "Test2", preferredCurrency: Currency.hkd ,budgets: [
//         BudgetEntry(nameParam: "first2", price: LocalizedPrice(valueParam: 2), entryType: BudgetEntryType(typeName: "Eat", iconData: Icons.fastfood.codePoint)),
//         BudgetEntry(nameParam: "second2", price: LocalizedPrice(valueParam: -5000))
//     ]),
//     BudgetThread(threadName: "Test", preferredCurrency: Currency.jpy, budgets: [
//         BudgetEntry(nameParam: "first", price: LocalizedPrice(valueParam: 2)),
//         BudgetEntry(nameParam: "second", price: LocalizedPrice(valueParam: -5))
//     ]),
//     BudgetThread(threadName: "Test3", preferredCurrency: Currency.euro, budgets: [
//         BudgetEntry(nameParam: "first3", price: LocalizedPrice(valueParam: 200)),
//         BudgetEntry(nameParam: "second3", price: LocalizedPrice(valueParam: 5000))
//     ])
//   ];

final entry1 = BudgetEntry(nameParam: "entry1", price: LocalizedPrice(valueParam: 12.3, currencyParam: Currency.hkd));
final entry2 = BudgetEntry(nameParam: "entry2", price: LocalizedPrice(valueParam: 1.5, currencyParam: Currency.hkd));
final entry3 = BudgetEntry(nameParam: "entry3", price: LocalizedPrice(valueParam: 45.6, currencyParam: Currency.jpy));

final thread1 = BudgetThread(threadName: "Test", preferredCurrency: Currency.hkd)..budgets.add(entry1)..budgets.add(entry2);
final thread2 = BudgetThread(threadName: "Test2", preferredCurrency: Currency.jpy)..budgets.add(entry3);
final thread3 = BudgetThread(threadName: "Test3", preferredCurrency: Currency.eur);

final List<BudgetThread> dummyBudgetThread = [thread1, thread2, thread3];

final List<BudgetEntryType> entryTypes = [
  BudgetEntryType.defaultType(), 
  BudgetEntryType.foodType(), 
  BudgetEntryType.transportType(), 
  BudgetEntryType.entertainmentType(), 
  BudgetEntryType.shoppingType(), 
];