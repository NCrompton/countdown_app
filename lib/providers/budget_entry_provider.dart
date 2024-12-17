import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:calendar/services/supabase_service.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'budget_entry_provider.g.dart';

@riverpod
class BudgetEntriesProvider extends _$BudgetEntriesProvider {

  late SupabaseService backup;
  late BudgetDatabase db;

  Future<List<BudgetEntry>> _fetchAllEntries() async {
    return db.getAllEntries();
  }

  // TODO: fix
  Future<void> resetAllBudgets(Id? threadId) async {
    ref.invalidate(budgetThreadProviderProvider);
    if (threadId != null) {
      ref.invalidate(budgetThreadEntryProviderProvider(threadId));
    }
  }

  @override
  Future<List<BudgetEntry>> build() async {
    state = const AsyncLoading();

    db = await BudgetDatabase.getInstance();
    backup = await ref.watch(supabaseServiceProvider.future);
    return _fetchAllEntries();
  }

  Future<bool> addEntries(BudgetEntry entry) async {
    bool success = true;
    await db.createEntry(entry);
    
    state = AsyncValue.data(await _fetchAllEntries());

    await resetAllBudgets(entry.thread.value?.id);
    backup.saveEntry(entry);
    return success;
  }

  Future<BudgetEntry?> getEntries(Id id) async {
    final entries = await (await BudgetDatabase.getInstance()).getEntry(id);
    return entries;
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      await db.updateEntry(entry);

      return await _fetchAllEntries();
    }, (_) => success = false);

    await resetAllBudgets(entry.thread.value?.id);
    backup.updateEntry(entry);
    return success;
  }

  Future<bool> deleteEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      entry.enabled = false; // disable the entry
      await db.updateEntry(entry);

      return _fetchAllEntries();
    }, (_) => (success = false));
    await resetAllBudgets(entry.thread.value?.id);
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
}

@riverpod
class BudgetThreadEntryProvider extends _$BudgetThreadEntryProvider {

  late BudgetDatabase db;
  late SupabaseService backup;

  Future<List<BudgetEntry>> _fetchAllEntriesOfThread() async {
    return db.getEntriesFromThread(threadId);
  }

  // TODO: fix
  Future<void> resetAllBudgets() async {
      ref.invalidate(budgetEntriesProviderProvider);
      ref.invalidate(budgetThreadProviderProvider);
  }

  @override
  Future<List<BudgetEntry>> build(Id threadId) async {
    state = const AsyncLoading();

    db = await BudgetDatabase.getInstance();
    backup = await ref.watch(supabaseServiceProvider.future);
    return await _fetchAllEntriesOfThread();
  }

  Future<bool> addNewEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      (await BudgetDatabase.getInstance()).createEntrySync(entry);
      await resetAllBudgets();

      return await _fetchAllEntriesOfThread();
    }, (_) => (success = false));

    backup.saveEntry(entry);
    return success;
  }

  Future<bool> updateEntryThread(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      db.updateEntrySync(entry);
      await resetAllBudgets();

      return await _fetchAllEntriesOfThread();
    }, (err) => (success = false));

    backup.updateEntry(entry);
    return success;
  }

  Future<bool> deleteEntry(Id id) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      final entry = await db.getEntry(id);
      final thread = entry!.thread.value;

      thread!.budgets.remove(entry);
      entry.thread.reset(); //TODO: check if it is needed
      await db.saveEntryToThread(thread);

      await db.updateEntry(entry); 

      return await _fetchAllEntriesOfThread();
    }, (_) => (success = false));

    backup.deleteEntry(id);
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