const targetDateConfig = "targetDateConfig";
const dateListConfig = "dateListConfig";
const String appGroupId = 'group.masonzen.countdown';
const String iOSWidgetNameCalendar = 'com.masonzen.calendar.Countdown';
const String androidWidgetNameCalendar = 'CountdownWidget'; 
const String fullAndroidWidgetNameCalendar = 'com.example.calendar.CountdownWidget'; 
const String iOSWidgetNameBudget = 'com.masonzen.calendar.Budget';
const String androidWidgetNameBudget = 'BudgetWidget'; 
const String fullAndroidWidgetNameBudget = 'com.example.calendar.BudgetWidget'; 

/* Widget Param Name */
const String widgetDateParamName = "countdown_date";
const String widgetNameParamName = "countdown_name";
const String widgetIntervalColorParamName = "countdown_interval_color";
const String widgetPrefIntervalFormParamName = "countdown_preferred_interval_format";

/* Budget Param Name */
const String widgetBudgetValueParamName = "budget_value";
const String widgetBudgetValueQueryName = "value";

/* color */
const int negativeColor = 0xffdd0000;
const int positiveColor = 0xff00AA00; 
const int beforeCountdownColor = negativeColor;
const int afterCountdownColor = positiveColor; 

/* feature flag */
const bool customIntervalFormatEnable = false;

/* widget callback */
const String callbackPrefix = "mason";
const String sBudgetWidgetCallback = "BudgetWidgetCallback";

/* budget logic */
const String defaultCurrency = "HKD";

/* Regular Expression */
//TODO: update from dd/mm/yyyy -> yyyy-mm-dd
const String nonLeapYearDateRegex = 
  r'(^(((0[1-9]|1[0-9]|2[0-8])[\/](0[1-9]|1[012]))|((29|30|31)[\/](0[13578]|1[02]))|((29|30)[\/](0[4,6,9]|11)))[\/](19|[2-9][0-9])\d\d$)';
const String leapYearDateRegex = 
  r'(^29[\/]02[\/](19|[2-9][0-9])(00|04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96)$)';
const String doubleRegex = r'^\d*\.?\d{0,2}';
const String intRegex = r'^\d*';