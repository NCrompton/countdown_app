import 'package:calendar/model/budget_schema.dart';

extension BudgetThreadUtil on BudgetThread {
  double getTotalBudget() {
    var total = 0.0;
    for (final b in budgets) {
      total += b.price.value;
    }
    return total;
  }

  DateTime? getStartDate() {
    if (budgets.isEmpty) return null;
    return budgets.first.entryTime;
  }

  DateTime? getEndDate() {
    if (budgets.isEmpty) return null;
    return budgets.last.entryTime;
  }
}

extension BudgetEntryListUtil on List<BudgetEntry> {
  void sortByCreateTimeAsc() {
    sort((a, b) => a.entryTime.compareTo(b.entryTime));
  }
}