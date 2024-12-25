import 'package:calendar/app.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/provider_watcher.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/logger.dart';
import 'package:calendar/utils/storage.dart';
import 'package:calendar/utils/widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  WidgetsFlutterBinding.ensureInitialized();
  _initWidgetValue();
  HomeWidget.registerInteractivityCallback(budgetWidgetCallback);

  runApp(
    ProviderScope(
      observers: [ProjectObserver()],
      child: const App(),
    ),
  );
}

void _initWidgetValue() async {
  LocalStorageManager.instance().then((m) async {
    final date = await m.getTargetDate();
    if (date == null) return;
    NativeWidgetManager().updateWidget(date.date, date.toString());
  });
}
// @pragma("vm:entry-point")
// void callbackDispatcher() async {
  
// }

@pragma("vm:entry-point")
Future<void> budgetWidgetCallback(Uri? data) async {
  final container = ProviderContainer(
    observers: [ProjectObserver()],
  );

  try {
    Log().log("Received callback: ${data?.scheme}://${data?.host}");
    if (data?.scheme != callbackPrefix.toLowerCase()) return;
    if (data?.host != sBudgetWidgetCallback.toLowerCase()) return;

    final storage = await LocalStorageManager.instance();
    final targetThreadId = storage.getTargetBudgetThread();
    
    // Initialize providers
    await container.read(budgetThreadProviderProvider.future);
    await container.read(budgetEntriesProviderProvider(targetThreadId).future);
    final notifier = container.read(budgetEntriesProviderProvider(targetThreadId).notifier);

    // Process parameters
    if (data?.queryParameters[widgetBudgetValueQueryName] != null) {
      final value = double.parse(data!.queryParameters[widgetBudgetValueQueryName]!);
      
      // Get thread
      final thread = await container.read(budgetThreadProviderProvider.future)
          .then((threads) => threads.firstWhereOrNull((t) => t.id == targetThreadId));
      
      // Create and add entry
      final entry = BudgetEntry(
        price: LocalizedPrice(
          valueParam: value, 
          currencyParam: thread?.preferredCurrency,
        ), 
        threadParam: thread
      );

      (thread == null) 
      ? await notifier.createEntry(entry)
      : await notifier.addEntrytoThread(entry);
    }
  } catch (e, stack) {
    Log().e('Error in widget callback: $e\n$stack');
  } finally {
    container.dispose();
  }
}

