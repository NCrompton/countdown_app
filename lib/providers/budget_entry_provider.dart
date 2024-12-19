import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:calendar/services/supabase_service.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'budget_entry_provider.g.dart';

@riverpod
class BudgetEntriesProvider extends _$BudgetEntriesProvider {

  late BudgetDatabase db;
  late SupabaseService backup;

  Future<List<BudgetEntry>> _fetchAllEntries() async {
    if (threadId == null) return db.getAllEntries();
    return db.getEntriesFromThread(threadId!);
  }

  // TODO: fix
  Future<void> resetAllBudgets(Id? id) async {
      // ref.invalidate(budgetEntriesProviderProvider);
      ref.invalidate(budgetThreadProviderProvider);
      if (threadId != null) {
        ref.invalidate(budgetEntriesProviderProvider(null));
      } else if (id != null){
        ref.invalidate(budgetEntriesProviderProvider(id));
      }
  }

  @override
  Future<List<BudgetEntry>> build(Id? threadId) async {
    state = const AsyncLoading();

    db = await BudgetDatabase.getInstance();
    backup = await ref.watch(supabaseServiceProvider.future);
    return await _fetchAllEntries();
  }

  Future<bool> createEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      db.createEntrySync(entry);
      await resetAllBudgets(entry.thread.value?.id);

      return await _fetchAllEntries();
    }, (_) => (success = false));

    backup.saveEntry(entry);
    return success;
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      db.updateEntrySync(entry);

      await resetAllBudgets(entry.thread.value?.id);
      return await _fetchAllEntries();
    }, (err) => (success = false));

    backup.updateEntry(entry);
    return success;
  }

  Future<bool> deleteEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      entry.enabled = false;
      await db.updateEntry(entry);

      await resetAllBudgets(entry.thread.value?.id);
      return await _fetchAllEntries();
    }, (_) => (success = false));

    backup.deleteEntry(entry.id);
    return success;
  }

  Future<bool> hardDeleteEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      final thread = entry.thread.value;
      // TODO: delete
      if (thread != null) {
        await db.saveEntryToThread(thread);
      }
      return _fetchAllEntries();
    }, (_) => (success = false));
    await resetAllBudgets(entry.thread.value?.id);
    backup.deleteEntry(entry.id);
    return success;
  }

  Future<bool> addEntrytoThread(BudgetEntry entry) async {
    if (threadId == null) return false;
    final thread = await db.getThread(threadId!);
    entry.thread.value = thread;
    return await updateEntry(entry);
  }

  Future<bool> removeEntryfromThread(BudgetEntry entry) async {
    entry.thread.value = null;
    return await updateEntry(entry);
  }

/// for reference how to handle async backlink
  Future<bool> createEntryAsync(BudgetEntry entry) async {
    bool success = true;
    final thread = entry.thread.value;
    state = await AsyncValue.guard(() async {
      await db.createEntry(entry);

      if (thread != null) {
        thread.budgets.add(entry);
        await db.saveEntryToThread(thread);
      }

      await resetAllBudgets(entry.thread.value?.id);
      return await _fetchAllEntries();
    }, (_) => (success = false));

    backup.saveEntry(entry);
    return success;
  }
}

@riverpod
class BudgetEntryTypeProvider extends _$BudgetEntryTypeProvider {

  late BudgetDatabase db;

  Future<List<BudgetEntryType>> _fetchAllTypes() async {
    final userTypes = await db.getAllEntryTypes();
    final List<BudgetEntryType> defaultTypes = [
      BudgetEntryType.defaultType(), 
      BudgetEntryType.foodType(), 
      BudgetEntryType.transportType(), 
      BudgetEntryType.entertainmentType(), 
      BudgetEntryType.shoppingType(), 
    ];
    return [...defaultTypes, ...userTypes];
  }

  @override
  Future<List<BudgetEntryType>> build() async {
    state = const AsyncLoading();

    db = await BudgetDatabase.getInstance();
    return _fetchAllTypes();
  }

  Future<void> createType(BudgetEntryType type) async {
    await db.createEntryType(type);
    state = AsyncValue.data(await _fetchAllTypes());
  }
}