package com.example.calendar

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
//import kotlin.time.Duration

/**
 * Implementation of App Widget functionality.
 */
class CountdownWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}


fun formatLocalDateTime(dateTime: LocalDateTime, format: String): String {
    val formatter = DateTimeFormatter.ofPattern(format)
    return dateTime.format(formatter)
}

/**
    [d/D]: Day, [h/H]: Hour, [m/M]: Minute
*/
fun parseIntervalFormat(interval: Duration, intervalFormat: String): String {
    val includeDay = intervalFormat.contains("d", ignoreCase = true)
    val includeHour = intervalFormat.contains("h", ignoreCase = true)
    val includeMinute = intervalFormat.contains("m", ignoreCase = true)

    var resultString = ""
    var daysNum = interval.toDays()

    if (includeDay && !includeHour && !includeMinute) {
        resultString += interval.toDays().toString()
    } else if (includeDay) {
        resultString += interval.toDays().toString() + "D"
    }

    if (includeHour) {
        resultString += interval.minusDays(interval.toDays()).toString() + "m"
    }

    if (includeMinute) {
        resultString += interval.minusHours(interval.toHours()).toString() + "s"
    }

    return resultString
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetData = HomeWidgetPlugin.getData(context)
    val standardTimeFormat = context.getString(R.string.standard_datetime_format)
    val standardIntervalFormat = context.getString(R.string.standard_interval_format)
    val views = RemoteViews(context.packageName, R.layout.countdown_widget).apply {
        var dateString = widgetData.getString("countdown_date", null)
        val preferredTimeFormat = widgetData.getString("preferred_time_format", null).takeIf { it != null } ?: standardTimeFormat
        val preferredIntervalFormat = widgetData.getString("preferred_interval_format", null).takeIf { it != null } ?: standardIntervalFormat
        val date = LocalDateTime.parse(dateString, DateTimeFormatter.ofPattern(standardTimeFormat))
        dateString = formatLocalDateTime(date, preferredTimeFormat)

        val dateName = widgetData.getString("countdown_name", null)

        val dateNamePrefix = if (date.isBefore(LocalDateTime.now())) "Since" else "To"

        val interval = if (date.isBefore(LocalDateTime.now()))
            Duration.between(date, LocalDateTime.now()) else
            Duration.between(LocalDateTime.now(), date)

        val intervalString = parseIntervalFormat(interval, preferredIntervalFormat)

        setTextViewText(R.id.date_as_string, dateString)
        setTextViewText(R.id.date_name, dateName)
        setTextViewText(R.id.date_name_prefix, dateNamePrefix)
        setTextViewText(R.id.interval_string, intervalString)
    }
    appWidgetManager.updateAppWidget(appWidgetId, views)
}