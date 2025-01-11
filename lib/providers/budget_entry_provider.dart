import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/budget_service.dart';
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
    return (await ref.read(budgetServiceProvider.future))
      .getEntriesFromThread(threadId);
  }

  @override
  Future<List<BudgetEntry>> build(Id? threadId) async {
    state = const AsyncLoading();
    ref.keepAlive();
    ref.onDispose(() => Log().d("provider disposed"));
    
    return await _fetchAllEntries();
  }

  Function _factory(BudgetEntry entry) {
    return () => _notifyAllEntryAdd(entry);
  }

  void _notifyAllEntryAdd(BudgetEntry entry) => 
    ref.read(budgetEntriesProviderProvider(BudgetThread.allEntryId).notifier)
      .addEntryToState(entry);

  void _notifyAllEntryUpdate(BudgetEntry entry) => 
    ref.read(budgetEntriesProviderProvider(BudgetThread.allEntryId).notifier)
      .updateEntryForState(entry);

  void _notifyAllEntryDelete(BudgetEntry entry) => 
    ref.read(budgetEntriesProviderProvider(BudgetThread.allEntryId).notifier)
      .removeEntryFromState(entry);

  void _notifyStateAdd(Id? threadId, BudgetEntry entry) => 
    ref.read(BudgetEntriesProviderProvider(threadId).notifier)
      .addEntryToState(entry);

  void _notifyThreadAdd(Id? threadId, BudgetEntry entry) => 
    ref.read(budgetThreadProviderProvider.notifier)
      .updateThreadMeta(threadId, entry);

  void _notifyThreadDelete(Id? threadId, BudgetEntry entry) => 
    ref.read(budgetThreadProviderProvider.notifier)
      .removeThreadMeta(threadId, entry);

  // List<Function> _notifyAdd(BudgetEntry entry) => [
  //   _factory(entry),
  //   _notifyThreadAdd,
  // ]

  Future<List<BudgetEntry>> _copyStateWithoutEntry(BudgetEntry entry) async {
    final copy = state.value ?? await _fetchAllEntries();
    return copy..removeWhere((e) => e.id == entry.id);
  }

  Future<bool> createEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final copy = await _copyStateWithoutEntry(entry); // would not remove anything if entry no exist in state
      final success = await ref.read(budgetServiceProvider.future)
        .then((s) => s.createEntry(entry)) >= 0;
      if (!success) throw EntryNotAddException();
      
      _notifyAllEntryAdd(entry);
      _notifyThreadAdd(entry.thread.value?.id, entry);
      return [entry, ...copy]..sortByCreateTimeAsc();
    }, (_) => (success = false));

    ref.read(supabaseServiceProvider.notifier).saveEntry(entry);
    return success;
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    bool success = true;
    state = await AsyncValue.guard(() async {
      final copy = await _copyStateWithoutEntry(entry);
      Log().d(copy.map((e) => e.entryName));

      success = await ref.read(budgetServiceProvider.future)
        .then((s) => s.updateEntry(entry));
      if (!success) throw EntryNotAddException();

      // need to notify thread provider from new thread to change the state
      _notifyAllEntryUpdate(entry);
      _notifyThreadDelete(entry.thread.value?.id, entry);
      _notifyThreadAdd(entry.thread.value?.id, entry);

      final newThread = entry.thread.value;
      final threadUpdated = newThread?.id != threadId;
      if (!threadUpdated) return [entry, ...copy]..sortByCreateTimeAsc();
      
      // thread change operation
      _notifyAllEntryUpdate(entry);
      _notifyStateAdd(entry.thread.value?.id, entry);
      _notifyThreadAdd(entry.thread.value?.id, entry);
      _notifyThreadDelete(threadId, entry);
      return copy..sortByCreateTimeAsc();
    }, (err) => (success = false));

    ref.read(supabaseServiceProvider.notifier).updateEntry(entry);
    return success;
  }

  Future<void> deleteEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final copy = await _copyStateWithoutEntry(entry);
      
      final success = await ref.read(budgetServiceProvider.future)
        .then((s) => s.deleteEntry(entry));
      if (!success) throw EntryNotAddException();

      _notifyAllEntryDelete(entry);
      _notifyThreadDelete(entry.thread.value?.id, entry);
      return copy..sortByCreateTimeAsc();
    });

    ref.read(supabaseServiceProvider.notifier).deleteEntry(entry.id);
  }

  Future<void> hardDeleteEntry(BudgetEntry entry) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final copy = await _copyStateWithoutEntry(entry);
      final success = await ref.read(budgetServiceProvider.future)
        .then((s) => s.deleteEntry(entry));
      if (!success) throw EntryNotAddException();

      _notifyAllEntryDelete(entry);
      _notifyThreadDelete(entry.thread.value?.id, entry);
      return copy..sortByCreateTimeAsc();
    });

    ref.read(supabaseServiceProvider.notifier).deleteEntry(entry.id);
  }

// notifier
  Future<void> addEntryToState(BudgetEntry entry) async {
    if (state.value == null) return;
    state = AsyncData(
      [entry, ...state.value!]
      ..sortByCreateTimeAsc()
    );
  }

  Future<void> removeEntryFromState(BudgetEntry entry) async {
    if (state.value == null) return;
    state = AsyncData(
      state.value!
      ..removeWhere((e) => e.id == entry.id)
      ..sortByCreateTimeAsc()
    );
  }
  
  Future<void> updateEntryForState(BudgetEntry entry) async {
    if (state.value == null) return;
    state = AsyncData(
      [entry, ...state.value!
        ..removeWhere((e) => e.id == entry.id)]
      ..sortByCreateTimeAsc()
    );
  }

// Exchange value in respect to state
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
    final db = await ref.read(budgetServiceProvider.future);
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
    state = await AsyncValue.guard(() async { 
      final tid = await ref.read(budgetServiceProvider.future)
        .then((s) => s.createEntryType(type));
      if (tid < 0) throw EntryNotAddException();

      return [type, ...state.value!];
    });
  }
}

class EntryNotAddException extends Error {

}