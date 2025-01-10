import 'package:calendar/model/budget_schema.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'budget_database.g.dart';

// TODO: use riverpod provide the service, which the service will operate on db and stored value
// TODO: provider should only work on state, service should work on data
@riverpod
class BudgetDatabase extends _$BudgetDatabase{
  late final Isar _isar;

  Future<Isar> _openConnection() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        BudgetThreadSchema, 
        BudgetEntrySchema, 
        BudgetEntryTypeSchema
      ],
      directory: dir.path,
    );
  }

  @override
  Future<BudgetDatabase> build() async {
    state = const AsyncLoading();
    ref.keepAlive();
    ref.onDispose(() => _isar.close);
    _isar = await _openConnection();
    return this;
  }
} 

extension BudgetThreadDatabase on BudgetDatabase {
  Future<BudgetThread?> getThread(Id id) async {
    return await _isar.budgetThreads.get(id);
  }

  Future<List<BudgetThread>> getAllThreads() async {
    return await threadQuery()
      .findAll();
  }

  Query<BudgetThread> threadQuery() => _isar.budgetThreads
    .where()
    .filter()
    .enabledEqualTo(true)
    .build();

  Future<Id> createThread(BudgetThread thread) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetThreads.put(thread);
    });
  }

  Future<bool> updateThread(BudgetThread thread) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetThreads.put(thread) > 0;
    });
  }

  Future<bool> deleteThread(BudgetThread thread) async {
    return await _isar.writeTxn(() async {
      thread.enabled = false;
      await thread.budgets.load();
      for (final e in thread.budgets) {
        e.enabled = false;
        _isar.budgetEntrys.put(e);
      }
      return await _isar.budgetThreads.put(thread) > 0;
    });
  }

  Future<bool> hardDeleteThread(BudgetThread thread) async {
    return await _isar.writeTxn(() async {
      await thread.budgets.load();
      for (final e in thread.budgets) {
        e.enabled = false;
        _isar.budgetEntrys.delete(e.id);
      }
      return await _isar.budgetThreads.delete(thread.id);
    });
  }

  Future<void> saveEntryToThread(BudgetThread thread) async {
    return await _isar.writeTxn(() async {
      await thread.budgets.save();
    });
  }

  Future<void> addExistingEntryToThread(Id threadId, Id entryId) async {
    return await _isar.writeTxn(() async {
      final thread = await _isar.budgetThreads.get(threadId);
      final entry = await _isar.budgetEntrys.get(entryId);

      if (thread == null || entry == null) return;
      entry.thread.value = thread;
      thread.budgets.add(entry);

      entry.thread.save();
      thread.budgets.save();
    });
  }

  Future<void> saveEntry (BudgetEntry entry) async {
    return await _isar.writeTxn(() async {
      await entry.thread.save();
      await entry.thread.value?.budgets.save();
    });
  }
}

extension BudgetEntryDatabase on BudgetDatabase {
  Future<BudgetEntry?> getEntry(Id id) async {
    return _isar.budgetEntrys.get(id);
  }

  Future<List<BudgetEntry>> getEntriesFromThread(Id? threadId) async {
    return await entriesQuery(threadId)
      .findAll()
      ..forEach((e) async => await loadThread(e));
  }

  Query<BudgetEntry> entriesQuery(Id? threadId) {
    var query = _isar.budgetEntrys
      .filter()
      .enabledEqualTo(true);
      if (threadId == null) {
        query = query.threadIsNull();
      } else if (threadId != BudgetThread.allEntryId) {
        query = query.thread((t) => t.idEqualTo(threadId));
      } 
    return query
      .sortByEntryTime()
      .build();
  }

  Future<Id> createEntry(BudgetEntry entry) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetEntrys.put(entry);
    });
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    return await _isar.writeTxn(() async {
      final oldE = (await _isar.budgetEntrys.get(entry.id));
      await oldE?.thread.load();

      final oldT = oldE?.thread.value;
      final newT = entry.thread.value;

      final eid = await _isar.budgetEntrys.put(entry);
      if (oldT == newT) return eid > 0; // thread not updated   

      if (newT == null) entry.thread.reset(); // if thread is removed
      entry.thread.save();
      
      oldT?.budgets.remove(oldE); // remove entry from old thread
      oldT?.budgets.save();

      newT?.budgets.add(entry); // add entry to new thread
      newT?.budgets.save();
      return eid > 0;
    });
  }

  Future<bool> deleteEntry(BudgetEntry entry) async {
    return await _isar.writeTxn(() async {
      entry.enabled = false;
      return await createEntry(entry) > 0;
    });
  }
  
  Future<bool> hardDeleteEntry(Id id) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetEntrys.delete(id);
    });
  }

/// sync transaction allow BackLink operation
  Id createEntrySync(BudgetEntry entry) {
    return _isar.writeTxnSync(() {
      return _isar.budgetEntrys.putSync(entry);
    });
  }

  bool updateEntrySync(BudgetEntry entry) {
    return _isar.writeTxnSync(() {
      return _isar.budgetEntrys.putSync(entry) > 0;
    });
  }

  Future<void> loadThread(BudgetEntry entry) async {
    return _isar.writeTxn(() async {
        await entry.thread.load();
    });
  }
}

extension BudgetEntryTypeDatabase on BudgetDatabase {
  Future<BudgetEntryType?> getEntryType(Id id) async {
    return _isar.budgetEntryTypes.get(id);
  }

  Future<List<BudgetEntryType>> getAllEntryTypes() async {
    return _isar.budgetEntryTypes.where().findAll();
  }

  Future<Id> createEntryType(BudgetEntryType type) async {
    return await _isar.writeTxn(() async {
      return _isar.budgetEntryTypes.put(type);
    });
  }

  Future<bool> updateEntryType(BudgetEntryType type) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetEntryTypes.put(type) > 0;
    });
  }

  Future<bool> deleteEntryType(Id id) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetEntryTypes.delete(id);
    });
  }
}