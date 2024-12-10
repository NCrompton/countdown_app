import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/utils/budget_util.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class BudgetDatabase {
  final Isar _isar;
  static BudgetDatabase? _instance;

  BudgetDatabase({required Isar isar}):_isar = isar;

  static Future<BudgetDatabase> getInstance() async {
    if (_instance == null) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [
          BudgetThreadSchema, 
          BudgetEntrySchema, 
          BudgetEntryTypeSchema
        ],
        directory: dir.path,
      );
      _instance = BudgetDatabase(isar: isar);
    }
    return _instance!;
  }
} 

extension BudgetThreadDatabase on BudgetDatabase {
  Future<BudgetThread?> getThread(Id id) async {
    return await _isar.budgetThreads.get(id);
  }

  Future<List<BudgetThread>> getAllThreads() async {
    return await _isar.budgetThreads.where().findAll();
  }

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

  Future<bool> deleteThread(Id id) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetThreads.delete(id);
    });
  }

  Future<void> saveEntryToThread(BudgetThread thread) async {
    return await _isar.writeTxn(() async {
      await thread.budgets.save();
    });
  }
}

extension BudgetEntryDatabase on BudgetDatabase {
  Future<BudgetEntry?> getEntry(Id id) async {
    return _isar.budgetEntrys.get(id);
  }

  Future<List<BudgetEntry>> getEntriesFromThread(Id threadId) async {
    return (await _isar.budgetThreads.filter().idEqualTo(threadId).findFirst())!.budgets.toList()
      ..sortByCreateTimeAsc();
  }

  Future<List<BudgetEntry>> getAllEntries() async {
    return _isar.budgetEntrys.where().sortByEntryTime().findAll();
  }

  Future<Id> createEntry(BudgetEntry entry) async {
    return await _isar.writeTxn(() async {
      return _isar.budgetEntrys.put(entry);
    });
  }

  Future<bool> updateEntry(BudgetEntry entry) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetEntrys.put(entry) > 0;
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

  Future<bool> deleteEntry(Id id) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetEntrys.delete(id);
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