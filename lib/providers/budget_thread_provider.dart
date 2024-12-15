import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:calendar/services/supabase_service.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_thread_provider.g.dart';

@riverpod
class BudgetThreadProvider extends _$BudgetThreadProvider {

    late BudgetDatabase db;
    late SupabaseService backup;

    Future<List<BudgetThread>> _fetchThreads() async {
      final threads = await db.getAllThreads();
      return threads;
    }

    @override
    Future<List<BudgetThread>> build() async {
      state = const AsyncValue.loading();

      db = await BudgetDatabase.getInstance();
      backup = await ref.read(supabaseServiceProvider.future);
      return _fetchThreads();
    } 

    Future<void> reload() async {
      state = const AsyncLoading();
      state = AsyncData(await _fetchThreads());
    }

    Future<void> addBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();

      await db.createThread(thread);
      state = AsyncData(await _fetchThreads());

      backup.saveThread(thread);
    }
    
    Future<void> updateBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();

      ref.read(supabaseServiceProvider.notifier).updateThread(thread);
      state = await AsyncValue.guard(() async {
        final db = await BudgetDatabase.getInstance();
        await db.updateThread(thread);
        return _fetchThreads();
      });
    }
    
    Future<void> deleteBudgetThread(Id threadId) async {
      state = const AsyncValue.loading();

      ref.read(supabaseServiceProvider.notifier).deleteThread(threadId);
      state = await AsyncValue.guard(() async {
        final db = await BudgetDatabase.getInstance();
        await db.deleteThread(threadId);
        // return state.value!..removeWhere((t) => t.id == threadId);
        return _fetchThreads();
      });
    }
}