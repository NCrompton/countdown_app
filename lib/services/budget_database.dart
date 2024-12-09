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
        [BudgetThreadSchema, BudgetEntrySchema],
        directory: dir.path,
      );
      _instance = BudgetDatabase(isar: isar);
    }
    return _instance!;
  }

  // Thread operations
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

  Future<void> saveEntryToThread(BudgetThread thread) async {
    return await _isar.writeTxn(() async {
      await thread.budgets.save();
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

  // Entry Operations
  Future<BudgetEntry?> getEntry(Id id) async {
    return _isar.budgetEntrys.get(id);
  }

  Future<List<BudgetEntry>> getEntriesFromThread(Id threadId) async {
    return (await _isar.budgetThreads.filter().idEqualTo(threadId).findFirst())!.budgets.toList()
      ..sortByCreateTimeAsc();
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

  Future<List<BudgetEntry>> getAllEntries() async {
    return _isar.budgetEntrys.where().sortByEntryTime().findAll();
  }

  Future<bool> deleteEntry(Id id) async {
    return await _isar.writeTxn(() async {
      return await _isar.budgetEntrys.delete(id);
    });
  }
} 