import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_service.g.dart';

mixin BudgetModelService {
  // THREAD

  Future<BudgetThread?> getThread(int id);

  Future<List<BudgetThread>> getAllThreads();

  Future<int> createThread(BudgetThread thread);

  Future<bool> updateThread(BudgetThread thread);

  Future<bool> deleteThread(BudgetThread thread);

  Future<bool> hardDeleteThread(BudgetThread thread);

  // ENTRY

  Future<BudgetEntry?> getEntry(int id);

  Future<List<BudgetEntry>> getEntriesFromThread(int? threadId);

  Future<int> createEntry(BudgetEntry entry);

  Future<bool> updateEntry(BudgetEntry entry);

  Future<bool> deleteEntry(BudgetEntry entry);
  
  Future<bool> hardDeleteEntry(BudgetEntry entry);

  // ENTRY TYPE

  Future<BudgetEntryType?> getEntryType(int id);

  Future<List<BudgetEntryType>> getAllEntryTypes();

  Future<int> createEntryType(BudgetEntryType type);

  Future<bool> updateEntryType(BudgetEntryType type);

  Future<bool> deleteEntryType(BudgetEntryType type);
}

@riverpod
class BudgetService extends _$BudgetService {
  @override
  Future<BudgetModelService> build() async {
    final service = await ref.watch(budgetDatabaseProvider.future);
    return service;
  }
}