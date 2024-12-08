import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_thread_provider.g.dart';

@riverpod
class BudgetThreadProvider extends _$BudgetThreadProvider {

    List<BudgetThread> threads = [];

    Future<List<BudgetThread>> _fetchThreads() async {
      final db = await BudgetDatabase.getInstance();

      final threads = await db.getAllThreads();
      return threads;
    }

    @override
    Future<List<BudgetThread>> build() async {
      state = const AsyncValue.loading();
      return _fetchThreads();
    } 

    Future<void> reload() async {
      state = const AsyncLoading();
      state = AsyncData(await _fetchThreads());
    }

    Future<void> addBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();

      final db = await BudgetDatabase.getInstance();
      await db.createThread(thread);
      state = AsyncData([...(state.value ?? []), thread]);
    }
    
    Future<void> updateBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        final db = await BudgetDatabase.getInstance();
        await db.updateThread(thread);
        return _fetchThreads();
      });
    }
    
    Future<void> deleteBudgetThread(Id threadId) async {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        final db = await BudgetDatabase.getInstance();
        await db.deleteThread(threadId);
        // return state.value!..removeWhere((t) => t.id == threadId);
        return _fetchThreads();
      });
    }
}