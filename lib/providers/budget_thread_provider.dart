import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/services/budget_service.dart';
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
      final db = await ref.read(budgetServiceProvider.future);
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

    void _noitfyEntryDelete(BudgetEntry entry) =>
      ref.read(budgetEntriesProviderProvider(BudgetThread.allEntryId).notifier)
        .removeEntryFromState(entry);

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

    Future<List<BudgetThread>> _copyStateWithoutThread(BudgetThread thread) async {
      final copy = state.value ?? await _fetchThreads();
      return copy..removeWhere((t) => t.id == thread.id);
    }

    Future<void> addBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final copy = await _copyStateWithoutThread(thread);

        final success = await ref.read(budgetServiceProvider.future)
            .then((db) => db.createThread(thread)) >= 0;
        if (!success) throw ThreadNotAddError();

        return [thread, ...copy];
      });

      ref.read(supabaseServiceProvider.notifier).saveThread(thread);
    }
    
    Future<void> updateBudgetThread(BudgetThread thread) async {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        final copy = await _copyStateWithoutThread(thread);

        final success = await ref.read(budgetServiceProvider.future)
          .then((db) => db.updateThread(thread));
        if (!success) throw ThreadNotAddError();

        return [thread, ...copy];
      });

      ref.read(supabaseServiceProvider.notifier).updateThread(thread);
    }
    
    Future<void> deleteBudgetThread(BudgetThread thread) async {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        final copy = await _copyStateWithoutThread(thread);

        final success = await ref.read(budgetServiceProvider.future)
          .then((db) => db.deleteThread(thread));
        if (!success) throw ThreadNotAddError();

        thread.budgets.forEach(_noitfyEntryDelete);
        
        return copy;
      });

      ref.read(supabaseServiceProvider.notifier).deleteThread(thread.id);
    }

    Future<void> hardDeleteBudgetThread(BudgetThread thread) async {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        final copy = await _copyStateWithoutThread(thread);
        
        final success = await ref.read(budgetServiceProvider.future)
          .then((db) => db.hardDeleteThread(thread));
        if (!success) throw ThreadNotAddError();

        thread.budgets.forEach(_noitfyEntryDelete);

        return copy;
      });

      ref.read(supabaseServiceProvider.notifier).deleteEntry(thread.id);
    }

// notifier
    Future<List<BudgetThread>> _updateThreadFromState(BudgetThread thread) async {
      final copy = state.value ?? await _fetchThreads();
      return [thread, ...copy..removeWhere((t) => t.id == thread.id)];
    }

    void removeThreadMeta(Id? threadId, BudgetEntry entry) async {
      final thread = state.value?.firstWhereOrNull((t) => t.id == threadId);
      if (thread == null) return; // return if thread == null || entry.thread.value == null || no thread found
      thread.budgets.remove(thread.budgets.firstWhereOrNull((e) => e.id == entry.id));

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

class ThreadNotAddError extends Error{}