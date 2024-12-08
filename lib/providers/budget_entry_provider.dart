import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'budget_entry_provider.g.dart';

@Riverpod(keepAlive: true)
class BudgetEntriesProvider extends _$BudgetEntriesProvider {

  late BudgetDatabase _database;
  List<BudgetEntry> entries = [];

  Future<List<BudgetEntry>> _fetchAllEntries() async {
    _database = await BudgetDatabase.getInstance();
    return _database.getAllEntries();
  }

  @override
  Future<List<BudgetEntry>> build() async {
    return _fetchAllEntries();
  }

  void addEntries(BudgetEntry entry) async {
    state = const AsyncLoading();
    _database.createEntry(entry);

    final entries = await _fetchAllEntries();
    state = AsyncValue.data(entries);
    // state = AsyncData([...state.value ?? [], entry]);
  }

  Future<BudgetEntry?> getEntries(Id id) async {
    final data = entries.firstWhereOrNull((e) => e.id == id);
    return data;
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    state = const AsyncLoading();
    if (await _database.updateEntry(entry)) {
      state = AsyncData(await _fetchAllEntries());
      return true;
    } 
    return false;
  }
}

@riverpod
class BudgetThreadEntryProvider extends _$BudgetThreadEntryProvider {

  late Id threadId;

  Future<List<BudgetEntry>> _fetchAllEntriesOfThread() async {
    final db = await BudgetDatabase.getInstance();
    return db.getEntriesFromThread(threadId);
  }

  @override
  Future<List<BudgetEntry>> build(Id threadId) {
    this.threadId = threadId;
    return _fetchAllEntriesOfThread();
  }

  Future<void> addNewEntry(BudgetEntry entry) async {
    state = const AsyncValue.loading();

    final db = await BudgetDatabase.getInstance();

    await db.createEntry(entry);

    final thread = await db.getThread(threadId);
    thread!.budgets.add(entry);
    await db.saveEntryToThread(thread);

    ref.read(budgetEntriesProviderProvider.notifier).build();
    ref.read(budgetThreadProviderProvider.notifier).build();

    state = AsyncData(await _fetchAllEntriesOfThread());
  }
}