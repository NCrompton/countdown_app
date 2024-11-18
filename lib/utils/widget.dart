import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:home_widget/home_widget.dart';

class NativeWidgetManager {
  static final NativeWidgetManager _manager = NativeWidgetManager._internal();
  bool isReady = false;

  NativeWidgetManager._internal() {
    HomeWidget.setAppGroupId(appGroupId);
    HomeWidget.getInstalledWidgets().then((v) {
      if (v.isEmpty) return;
      isReady = true;
    });
  }

  factory NativeWidgetManager() => _manager; 

  void setWidgetDate(DateTime date) {
      HomeWidget.saveWidgetData<String>(
          widgetDateParamName, date.formateDateStringToStandard());
  }

  void setWidgetDateName(String name) {
      HomeWidget.saveWidgetData<String>(
          widgetNameParamName, name);
  }

  void updateWidget(DateTime date, String name) {
      setWidgetDate(date);
      setWidgetDateName(name);
      HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
        qualifiedAndroidName: fullAndroidWidgetName,
      );
  }
}