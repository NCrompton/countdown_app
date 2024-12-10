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

  // TODO: fix
  Future<void> notifyThread() async {
      await ref.read(budgetThreadProviderProvider.notifier).reload();
  }

  @override
  Future<List<BudgetEntry>> build() async {
    state = const AsyncLoading();
    return _fetchAllEntries();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchAllEntries());
  }

  Future<bool> addEntries(BudgetEntry entry) async {
    bool success = true;
    final db = await BudgetDatabase.getInstance();
    await db.createEntry(entry);
    
    state = AsyncValue.data(await _fetchAllEntries());
    await notifyThread();
    return success;
  }

  Future<BudgetEntry?> getEntries(Id id) async {
    final entries = await (await BudgetDatabase.getInstance()).getEntry(id);
    return entries;
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    bool success = true;
    final db = await BudgetDatabase.getInstance();
    state = await AsyncValue.guard(() async {
      await db.updateEntry(entry);

      return _fetchAllEntries();
    }, (_) => success = false);
    await notifyThread();
    return success;
  }

  Future<bool> deleteEntry(Id id) async {
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
    await notifyThread();
    return success;
  }
}

@riverpod
class BudgetThreadEntryProvider extends _$BudgetThreadEntryProvider {

  Future<List<BudgetEntry>> _fetchAllEntriesOfThread() async {
    final db = await BudgetDatabase.getInstance();
    return db.getEntriesFromThread(threadId);
  }

  // TODO: fix
  Future<void> notifyThread() async {
      await ref.read(budgetEntriesProviderProvider.notifier).reload();
      await ref.read(budgetThreadProviderProvider.notifier).reload();
  }

  @override
  Future<List<BudgetEntry>> build(Id threadId) {
    state = const AsyncLoading();
    return _fetchAllEntriesOfThread();
  }
  

  Future<bool> addNewEntry(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      (await BudgetDatabase.getInstance()).createEntrySync(entry);
      await notifyThread();

      return await _fetchAllEntriesOfThread();
    }, (_) => (success = false));
    return success;
  }

  Future<bool> updateEntryThread(BudgetEntry entry) async {
    bool success = true;
    state = await AsyncValue.guard(() async {
      (await BudgetDatabase.getInstance()).updateEntrySync(entry);
      await notifyThread();

      return await _fetchAllEntriesOfThread();
    }, (err) => (success = false));
    return success;
  }

  Future<bool> deleteEntry(Id id) async {
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

@riverpod
class BudgetEntryTypeProvider extends _$BudgetEntryTypeProvider {

  Future<List<BudgetEntryType>> _fetchAllTypes() async {
    final db = await BudgetDatabase.getInstance();
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
    return _fetchAllTypes();
  }

  Future<void> createType(BudgetEntryType type) async {
    final db = await BudgetDatabase.getInstance();
    await db.createEntryType(type);
    state = AsyncValue.data(await _fetchAllTypes());
  }
}