package com.example.calendar

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.time.Duration
import java.time.LocalDate
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

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetData = HomeWidgetPlugin.getData(context)
    val views = RemoteViews(context.packageName, R.layout.countdown_widget).apply {
        var dateString = widgetData.getString("countdown_date", null)
        val date = LocalDateTime.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"))
        dateString = LocalDateTime.now().toString()
        val counter = widgetData.getInt("countdown_counter", 0)

        val interval = Duration.between(LocalDateTime.now(), date)
//        val intervalString = interval.toDays().toString()
        val intervalString = interval.toDays().toString()

        setTextViewText(R.id.date_string, dateString)
        setTextViewText(R.id.counter_string, counter.toString())
        setTextViewText(R.id.interval_string, intervalString)
    }

    val widgetText = context.getString(R.string.appwidget_text)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}