import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:calendar/services/exchange_service.dart';
import 'package:calendar/services/supabase_service.dart';
import 'package:calendar/utils/budget_util.dart';
import 'package:calendar/utils/logger.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'budget_entry_provider.g.dart';

@riverpod
class BudgetEntriesProvider extends _$BudgetEntriesProvider {
  Future<List<BudgetEntry>> _fetchAllEntries() async {
    Log().log("refetching all entry from $threadId");
    return (await ref.read(budgetDatabaseProvider.future))
      .getEntriesFromThread(threadId);
  }

  @override
  Future<List<BudgetEntry>> build(Id? threadId) async {
    state = const AsyncLoading();
    ref.keepAlive();
    ref.onDispose(() => Log().d("provider disposed"));
    
    return await _fetchAllEntries();
  }

  void _notifyEntryAdd({required BudgetEntry entry, Id? id = BudgetThread.allEntryId} ) {
    ref.read(budgetThreadProviderProvider.notifier).updateThreadMeta(entry.thread.value?.id, entry);
    ref.read(budgetEntriesProviderProvider(id).notifier)
      .addEntryToThread(entry);
  }

  void _notifyEntryDelete({required BudgetEntry entry, Id? id = BudgetThread.allEntryId} ) {
    ref.read(budgetThreadProviderProvider.notifier).removeThreadMeta(entry.thread.value?.id, entry);
    ref.read(budgetEntriesProviderProvider(id).notifier)
      .removeEntryfromThread(entry);
  }
  
  void _notifyEntryUpdated({required BudgetEntry entry, Id? id = BudgetThread.allEntryId} ) {
    ref.read(budgetThreadProviderProvider.notifier).updateThreadMeta(entry.thread.value?.id, entry);
    ref.read(budgetEntriesProviderProvider(id).notifier)
      .updateEntryforThread(entry);
  }

  Future<bool> createEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final copy = state.value ?? await _fetchAllEntries();
      ref.read(budgetDatabaseProvider.future)
        .then((db) => db.createEntry(entry));
      
      _notifyEntryAdd(entry: entry);
      return [entry, ...copy]..sortByCreateTimeAsc();
    }, (_) => (success = false));

    ref.read(supabaseServiceProvider.notifier).saveEntry(entry);
    return success;
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final copy = state.value ?? await _fetchAllEntries();
      final newThread = entry.thread.value;

      ref.read(budgetDatabaseProvider.future)
        .then((db) => db.updateEntry(entry));

      copy.removeWhere((e) => e.id == entry.id);

      // need to notify thread provider from new thread to change the state
      _notifyEntryUpdated(entry: entry);
      if (newThread?.id != threadId) { 
        _notifyEntryAdd(entry: entry, id: newThread?.id);
        ref.read(budgetThreadProviderProvider.notifier).removeThreadMeta(threadId, entry);
        return copy..sortByCreateTimeAsc();
      }
      return [entry, ...copy]..sortByCreateTimeAsc();
    }, (err) => (success = false));

    ref.read(supabaseServiceProvider.notifier).updateEntry(entry);
    return success;
  }

  Future<bool> deleteEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final copy = state.value ?? await _fetchAllEntries();
      
      ref.read(budgetDatabaseProvider.future)
        .then((db) => db.deleteEntry(entry));

      _notifyEntryDelete(entry: entry);
      copy.removeWhere((e) => e.id == entry.id);
      return copy..sortByCreateTimeAsc();
    }, (_) => (success = false));

    ref.read(supabaseServiceProvider.notifier).deleteEntry(entry.id);
    return success;
  }

  Future<bool> hardDeleteEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final copy = state.value ?? await _fetchAllEntries();
      ref.read(budgetDatabaseProvider.future)
        .then((db) => db.deleteEntry(entry));

      _notifyEntryDelete(entry: entry);
      copy.removeWhere((e) => e.id == entry.id);
      return copy..sortByCreateTimeAsc();
    }, (_) => (success = false));

    ref.read(supabaseServiceProvider.notifier).deleteEntry(entry.id);
    return success;
  }

  Future<bool> addEntrytoThread(BudgetEntry entry) async {
    Log().log("Adding entry to Thread $threadId");
    if (threadId == null) return false;
    final db = await ref.read(budgetDatabaseProvider.future);
    final thread = await db.getThread(threadId!);
    entry.thread.value = thread;
    return await updateEntry(entry);
  }

// notifier
  Future<void> addEntryToThread(BudgetEntry entry) async {
    if (state.value == null) return;
    state = AsyncData(
      [entry, ...state.value!]
      ..sortByCreateTimeAsc()
    );
  }

  Future<void> removeEntryfromThread(BudgetEntry entry) async {
    if (state.value == null) return;
    state = AsyncData(
      state.value!
      ..removeWhere((e) => e.id == entry.id)
      ..sortByCreateTimeAsc()
    );
  }
  
  Future<void> updateEntryforThread(BudgetEntry entry) async {
    if (state.value == null) return;
    state = AsyncData(
      [entry, ...state.value!
        ..removeWhere((e) => e.id == entry.id)]
      ..sortByCreateTimeAsc()
    );
  }

/// for reference how to handle async backlink
  Future<bool> createEntryAsync(BudgetEntry entry) async {
    bool success = true;
    final thread = entry.thread.value;
    state = await AsyncValue.guard(() async {
      final db = await ref.read(budgetDatabaseProvider.future);
      db.createEntry(entry);

      if (thread != null) {
        thread.budgets.add(entry);
        await db.saveEntryToThread(thread);
      }

      return await _fetchAllEntries();
    }, (_) => (success = false));

    ref.read(supabaseServiceProvider.notifier).saveEntry(entry);
    return success;
  }

  Future<double> _getExchangedTotal(List<BudgetEntry> entries) async {
    await ref.read(exchangeServiceProvider.future);
    double total = 0;
    for (var e in entries) {
      total += ref.read(exchangeServiceProvider.notifier).getExchangedPrice(e.price);
    }
    return total;
  }

  Future<double> exchangedTotalSpending() async {
    final entries = state.value!;
    return _getExchangedTotal(entries);
  }

  Future<double> exchangeEntryTypeTotal(BudgetEntryType type) async {
    final entries = state.value!.where((e) => e.entryType == type.id).toList();
    return _getExchangedTotal(entries);
  }
}

@riverpod
class BudgetEntryTypeProvider extends _$BudgetEntryTypeProvider {

  Future<List<BudgetEntryType>> _fetchAllTypes() async {
    final db = await ref.read(budgetDatabaseProvider.future);
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
    ref.keepAlive();

    return _fetchAllTypes();
  }

  Future<void> createType(BudgetEntryType type) async {
    final db = await ref.read(budgetDatabaseProvider.future);
    await db.createEntryType(type);
    state = AsyncValue.data(await _fetchAllTypes());
  }
}