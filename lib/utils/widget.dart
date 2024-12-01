import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  void _setWidgetDate(DateTime date) {HomeWidget.saveWidgetData<String>(widgetDateParamName, date.formateDateStringToStandard());}

  void _setWidgetDateName(String name) {HomeWidget.saveWidgetData<String>(widgetNameParamName, name);}

  void _setWidgetIntervalColor(String colorHex) {HomeWidget.saveWidgetData<String>(widgetIntervalColorParamName, colorHex);}

  void _setPreferedIntervalFormat(String preferredTimeFormat) {HomeWidget.saveWidgetData(widgetPrefIntervalFormParamName, preferredTimeFormat);}

  void _renderFlutterWidget(Widget widget, String key, Size size) async {
    var path = await HomeWidget.renderFlutterWidget(
      widget,
      key: key,
      logicalSize: size,
    );
    print(path);
  }

  void _updateCalendarWidget() {
      HomeWidget.updateWidget(
        iOSName: iOSWidgetNameCalendar,
        androidName: androidWidgetNameCalendar,
        qualifiedAndroidName: fullAndroidWidgetNameCalendar,
      );
  }
  
  void _updateBudgetWidget() {
      HomeWidget.updateWidget(
        iOSName: iOSWidgetNameBudget,
        androidName: androidWidgetNameBudget,
        qualifiedAndroidName: fullAndroidWidgetNameBudget,
      );
  }

  /* Calendar */
  void updateWidget(DateTime date, String name) {
      _setWidgetDate(date);
      _setWidgetDateName(name);
      _updateCalendarWidget();
  }

  void resetWidget() {
    _setWidgetDate(DateTime.now());
    _setWidgetDateName("");
    _updateCalendarWidget();
  }

  void countdownTimeFormat(bool day, bool hour, bool minute, bool second) {
    String preferredTimeFormat = "";
    preferredTimeFormat += day ? "d" : "";
    preferredTimeFormat += hour ? "h" : "";
    preferredTimeFormat += minute ? "m" : "";
    preferredTimeFormat += second ? "s" : "";
    _setPreferedIntervalFormat(preferredTimeFormat);
    _updateCalendarWidget();
  }

  void renderCountdownWidgetBackground(String bgAssetPath) async {
    await rootBundle.load(bgAssetPath);
    Widget widget = Container(child: Image.asset(bgAssetPath), width: 400, height: 400,);

    _renderFlutterWidget(widget, "bgimage", const Size(400, 400));
  }

  /* Budget */
  void updateBudget(double value) {
    _updateBudgetWidget();
  }
}