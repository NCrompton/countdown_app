import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_thread_provider.g.dart';

@riverpod
class BudgetThreadProvider extends _$BudgetThreadProvider {

    late BudgetDatabase _database;
    List<BudgetThread> threads = [];

    Future<List<BudgetThread>> _fetchThreads() async {
      _database = await BudgetDatabase.getInstance();

      final threads = await _database.getAllThreads();
      return threads;
    }

    @override
    Future<List<BudgetThread>> build() async {
      state = const AsyncValue.loading();
      return _fetchThreads();
    } 

    Future<void> addBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();
      
      // final existing = state.value;
      // if (existing != null && existing.isEmpty) {state = AsyncData([thread]);};
      await _database.createThread(thread);
      state = AsyncData([...(state.value ?? []), thread]);

      // state = const AsyncData(v);
    }
}

//    Future<List<BudgetThread>> _fetchThreads() async {
//       _database = await BudgetDatabase.getInstance();
//       _isar = _database.isar;

//       final threads = await getAllThreads();
//       return threads;
//     }

//     @override
//     Future<List<BudgetThread>> build() async {
//       print("getting budget from db");
//       state = const AsyncValue.loading();
//       return _fetchThreads();
//     } 

//     // Thread operations
//     Future<BudgetThread?> getThread(Id id) async {
//       return await _isar.budgetThreads.get(id);
//     }

//     Future<List<BudgetThread>> getAllThreads() async {
//       return await _isar.budgetThreads.where().findAll();
//     }

//     Future<void> createThread(BudgetThread thread) async {
//       state = const AsyncLoading();

//       await _isar.writeTxn(() async {
//         await _isar.budgetThreads.put(thread);
//       });

//       state = await AsyncValue.guard(() async {
//         return _fetchThreads();
//       });
//     }

//     Future<bool> updateThread(BudgetThread thread) async {
//       return await _isar.writeTxn(() async {
//         return await _isar.budgetThreads.put(thread) > 0;
//       });
//     }

//     Future<bool> deleteThread(Id id) async {
//       return await _isar.writeTxn(() async {
//         return await _isar.budgetThreads.delete(id);
//       });
//     }

//     Future<void> addBudgetThread(BudgetThread thread) async {
//       state = const AsyncValue.loading();
      
//       // final existing = state.value;
//       // if (existing != null && existing.isEmpty) {state = AsyncData([thread]);};
//       await _database?.createThread(thread);
//       state = AsyncData([...(state.value ?? []), thread]);

//       // state = const AsyncData(v);
//     }