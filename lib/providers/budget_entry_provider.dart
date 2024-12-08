import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'budget_entry_provider.g.dart';

@riverpod
class BudgetEntriesProvider extends _$BudgetEntriesProvider {

  Future<List<BudgetEntry>> _fetchAllEntries() async {
    final db = await BudgetDatabase.getInstance();
    return db.getAllEntries();
  }

  @override
  Future<List<BudgetEntry>> build() async {
    return _fetchAllEntries();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchAllEntries());
  }

  void addEntries(BudgetEntry entry) async {
    state = const AsyncLoading();

    final db = await BudgetDatabase.getInstance();
    db.createEntry(entry);

    final entries = await _fetchAllEntries();
    state = AsyncValue.data(entries);
  }

  Future<BudgetEntry?> getEntries(Id id) async {
    final entries = await (await BudgetDatabase.getInstance()).getEntry(id);
    return entries;
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    final db = await BudgetDatabase.getInstance();
    if (await db.updateEntry(entry)) {
      state = AsyncData(await _fetchAllEntries());
      return true;
    } 
    return false;
  }

  Future<bool> deleteEntry(Id id) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final db = await BudgetDatabase.getInstance();
      final entry = await db.getEntry(id);

      final thread = entry!.thread.value;
      if (thread != null) {
        await db.saveEntryToThread(thread);
      }
      return _fetchAllEntries();
    }, (_) => (success = false));
    return success;
  }
}

@riverpod
class BudgetThreadEntryProvider extends _$BudgetThreadEntryProvider {

  Future<List<BudgetEntry>> _fetchAllEntriesOfThread() async {
    final db = await BudgetDatabase.getInstance();
    return db.getEntriesFromThread(threadId);
  }

  @override
  Future<List<BudgetEntry>> build(Id threadId) {
    return _fetchAllEntriesOfThread();
  }

  Future<bool> addNewEntry(BudgetEntry entry) async {
    state = const AsyncValue.loading();

    bool success = true;

    state = await AsyncValue.guard(() async {
      final db = await BudgetDatabase.getInstance();

      await (await BudgetDatabase.getInstance()).createEntry(entry);

      final thread = await db.getThread(threadId);

      thread!.budgets.add(entry);
      await db.saveEntryToThread(thread);

      // TODO: fix
      await ref.read(budgetEntriesProviderProvider.notifier).reload();
      await ref.read(budgetThreadProviderProvider.notifier).reload();

      return await _fetchAllEntriesOfThread();
    }, (_) => (success = false));

    return success;
  }

  Future<bool> deleteEntry(Id id) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final db = await BudgetDatabase.getInstance();

      final entry = await db.getEntry(id);
      final thread = entry!.thread.value;

      thread!.budgets.remove(entry);
      entry.thread.reset(); //TODO: check if it is needed
      await db.saveEntryToThread(thread);

      await db.updateEntry(entry); 

      return await _fetchAllEntriesOfThread();
    }, (_) => (success = false));

    return success;
  }
}