import 'package:calendar/app.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/services/budget_database.dart';
import 'package:calendar/services/provider_watcher.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/logger.dart';
import 'package:calendar/utils/storage.dart';
import 'package:calendar/utils/widget.dart';
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

    final targetThreadId = await container.read(targetThreadProvider.future);
    
    // Initialize providers
    final db = await container.read(budgetDatabaseProvider.future);
    final thread = targetThreadId == null ? null : await db.getThread(targetThreadId);

    // Process parameters
    if (data?.queryParameters[widgetBudgetValueQueryName] != null) {
      final value = double.parse(data!.queryParameters[widgetBudgetValueQueryName]!);

      Log().log("Target Thread is ${thread?.threadName}");
      // Create and add entry
      final entry = BudgetEntry(
        price: LocalizedPrice(
          valueParam: value, 
          currencyParam: thread?.preferredCurrency,
        ), 
        threadParam: thread
      );

      Log().d("Entry Thread is ${entry.thread.value?.threadName}");

      await db.createEntry(entry);
    }
  } catch (e, stack) {
    Log().e('Error in widget callback: $e\n$stack');
  } finally {
    container.dispose();
  }
}

