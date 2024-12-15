import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/.secret.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_service.g.dart';

@Riverpod(keepAlive: true)
class SupabaseService extends _$SupabaseService{
  
  static SupabaseService instance = SupabaseService();
  Supabase? supabase;
  Session? get session => supabase?.client.auth.currentSession;

  @override
  Future<SupabaseService> build() async {
    state = const AsyncLoading();
    return initSupabase();
  }

  Future<SupabaseService> initSupabase() async {
    instance.supabase = instance.supabase ?? await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_API_KEY,
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
    return instance;
  }

  Future<bool?> auth() async {
    return supabase?.client.auth.signInWithOAuth(
      OAuthProvider.google,
    );
  }
}

extension SupabaseData on SupabaseService {
  static final disableJson = {'disabled': true};

// Thread Operation
  Future<List<BudgetThread>?> getAllThreadFromSb() async {
    final res = await supabase?.client.from('BudgetThread').select();
    return res?.map(BudgetThread.fromJson).toList();
  }

  Future<void> saveThread(BudgetThread thread) async {
    await supabase?.client.from('BudgetThread').insert(thread.toJson()).select();
  }

  Future<void> updateThread(BudgetThread thread) async {
    await supabase?.client.from('BudgetThread').update(thread.toJson()).eq('id', thread.id);
  }

  Future<void> deleteThread(int threadId) async {
    await supabase?.client.from('BudgetThread').update(disableJson).eq('id', threadId);
  }
  
// Entry Operation
  Future<List<BudgetEntry>?> getAllEntryFromSb() async {
    final res = await supabase?.client.from('BudgetEntry').select();
    return res?.map(BudgetEntry.fromJson).toList();
  }

  Future<void> saveEntry(BudgetEntry entry) async {
    await supabase?.client.from('BudgetEntry').insert(entry.toJson()).select();
  }

  Future<void> updateEntry(BudgetEntry entry) async {
    await supabase?.client.from('BudgetEntry').update(entry.toJson()).eq('id', entry.id);
  }

  Future<void> deleteEntry(int entryId) async {
    await supabase?.client.from('BudgetEntry').update(disableJson).eq('id', entryId);
  }
  
// Type Operation
  Future<List<BudgetEntryType>?> getAllTypeFromSb() async {
    final res = await supabase?.client.from('BudgetEntryType').select();
    return res?.map(BudgetEntryType.fromJson).toList();
  }

  Future<void> saveType() async {
    final types = ref.watch(budgetEntryTypeProviderProvider).value;
    await supabase?.client.from('BudgetEntryType').insert(types!.map((v) => v.toJson()).toList()).select();
  }
}