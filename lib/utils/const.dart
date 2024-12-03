const targetDateConfig = "targetDateConfig";
const dateListConfig = "dateListConfig";
const String appGroupId = 'group.masonzen.countdown'; // Add from here
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

const String dateFormat = "yyyy-MM-dd HH:mm:ss";
const String dateDisplayFormat = "dd MMM y HH:mm";
const String dateDisplayShortFormat = "dd MMM y";

/* feature flag */
const bool customIntervalFormatEnable = false;

/* widget callback */
const String callbackPrefix = "mason";
const String sBudgetWidgetCallback = "BudgetWidgetCallback";

/* budget logic */
const String defaultCurrency = "HKD";