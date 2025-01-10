import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:calendar/services/supabase_service.dart';
import 'package:calendar/utils/logger.dart';
import 'package:calendar/utils/storage.dart';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_thread_provider.g.dart';

@riverpod
class BudgetThreadProvider extends _$BudgetThreadProvider {
    Future<List<BudgetThread>> _fetchThreads() async {
      Log().log("refetching threads");
      final db = await ref.read(budgetDatabaseProvider.future);
      final threads = await db.getAllThreads();

      final targetThreadId = await ref.read(targetThreadProvider.future);

      for (var t in threads) {
        t.isTarget = t.id == targetThreadId;
        _updateThreadPeriod(t);
      }

      return threads;
    }

    @override
    Future<List<BudgetThread>> build() async {
      state = const AsyncValue.loading();
      ref.keepAlive();

      _listenToDB();

      // require no refetch 
      ref.listen(targetThreadProvider.future, (_, targetId) async {
        final tid = await targetId;
        final threads = state.value!;
        for (var t in threads) {
          t.isTarget = t.id == tid;
        }
        state = AsyncData(threads);
      });

      return await _fetchThreads();
    } 

    Future<BudgetThread> _updateThreadPeriod(BudgetThread t) async {
      if (t.budgets.isEmpty) return t;
      t.beginDate = t.budgets
        .where((e) => e.enabled)
        .sorted((a, b) => a.entryTime.compareTo(b.entryTime)).first.entryTime;
      t.endDate = t.budgets
        .where((e) => e.enabled)
        .sorted((a, b) => a.entryTime.compareTo(b.entryTime)).last.entryTime;
      return t;
    }

    Future<List<BudgetThread>> _updateThreadFromState(BudgetThread thread) async {
      final copy = state.value ?? await _fetchThreads();
      return [thread, ...copy..removeWhere((t) => t.id == thread.id)];
    }

    void removeThreadMeta(Id? threadId, BudgetEntry entry) async {
      final thread = state.value?.firstWhereOrNull((t) => t.id == threadId);
      if (thread == null) return; // return if thread == null || entry.thread.value == null || no thread found
      thread.budgets.remove(thread.budgets.where((e) => e.id == entry.id).first);

      state = AsyncData(await _updateThreadFromState(await _updateThreadPeriod(thread)));
    }

    void updateThreadMeta(Id? threadId, BudgetEntry entry) async {
      final thread = state.value?.firstWhereOrNull((t) => t.id == threadId);
      if (thread == null) return; // return if thread == null || entry.thread.value == null || no thread found
      if (thread.endDate == null || entry.entryTime.isAfter(thread.endDate!)) {
        thread.endDate = entry.entryTime;
      }
      if (thread.beginDate == null || entry.entryTime.isBefore(thread.beginDate!)) {
        thread.beginDate = entry.entryTime;
      }
      
      state = AsyncData(await _updateThreadFromState(thread));
    }

    Future<void> _listenToDB() async {
      (await ref.read(budgetDatabaseProvider.future)).threadQuery()
        .watch()
        .listen((threads) async => 
          state = AsyncData(threads));
    }

    Future<void> addBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();
      final copy = state.value ?? await _fetchThreads();

      ref.read(budgetDatabaseProvider.future)
          .then((db) => db.createThread(thread));

      state = AsyncData([thread, ...copy]);

      ref.read(supabaseServiceProvider.notifier).saveThread(thread);
    }
    
    Future<void> updateBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        final copy = state.value ?? await _fetchThreads();

        ref.read(budgetDatabaseProvider.future)
          .then((db) => db.updateThread(thread));

        copy.removeWhere((t) => t.id == thread.id);
        return [thread, ...copy];
      });

      ref.read(supabaseServiceProvider.notifier).updateThread(thread);
    }
    
    Future<void> deleteBudgetThread(BudgetThread thread) async {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        final copy = state.value ?? await _fetchThreads();

        ref.read(budgetDatabaseProvider.future)
          .then((db) => db.deleteThread(thread));
        
        return copy..removeWhere((t) => t.id == thread.id);
      });

      ref.read(supabaseServiceProvider.notifier).deleteThread(thread.id);
    }

    Future<void> hardDeleteBudgetThread(BudgetThread thread) async {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        final copy = state.value ?? await _fetchThreads();
        
        ref.read(budgetDatabaseProvider.future)
          .then((db) => db.hardDeleteThread(thread));

        return copy..removeWhere((t) => t.id == thread.id);
      });

      ref.read(supabaseServiceProvider.notifier).deleteEntry(thread.id);
    }
}

@riverpod
class TargetThread extends _$TargetThread {
  
  @override
  Future<Id?> build() async {
    state = const AsyncLoading();
    return (await LocalStorageManager.instance()).getTargetBudgetThread();
  }

  void updateTargetThread(Id? id) {
    LocalStorageManager.instance()
      .then((storage) => storage.setTargetBudgetThread(id));
    state = AsyncData(id);
  }
}