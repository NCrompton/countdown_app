import 'package:calendar/model/budget_model.dart';

extension BudgetThreadUtil on BudgetThread {
  void addBudgets(BudgetEntry entry) {
    budgets = [...budgets, entry]; /* reuse budget sorting logic */
  }

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