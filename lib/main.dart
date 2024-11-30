import 'package:calendar/app.dart';
import 'package:calendar/utils/const.dart';
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
    const ProviderScope(
      child: App(),
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
  if (data?.scheme != callbackPrefix) return;
  if (data?.host != sBudgetWidgetCallback) return;
  
  print(data);
}

