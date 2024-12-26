import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:calendar/services/supabase_service.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_thread_provider.g.dart';

// TODO: now the state update twice everytime it is updated: {listenToDB, _fetchThreads}
// TODO: prevent calling late initialization of var 
// TODO: the function should act on the state, instead of just refetching the state
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
      await _listenToDB();

      ref.keepAlive();
      return _fetchThreads();
    } 

    Future<void> _listenToDB() async {
      db.threadQuery()
        .watch()
        .listen((threads) async => 
          state = AsyncData(threads));
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
    
    Future<void> deleteBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        thread.enabled = false;
        await db.updateThread(thread);
        // return state.value!..removeWhere((t) => t.id == threadId);
        return _fetchThreads();
      });

      await backup.deleteThread(thread.id);
    }

    Future<void> hardDeleteBudgetThread(Id threadId) async {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        await db.deleteThread(threadId);
        // return state.value!..removeWhere((t) => t.id == threadId);
        return _fetchThreads();
      });

      await backup.deleteEntry(threadId);
    }
}