package com.example.calendar

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.res.AssetManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.util.SizeF
import android.widget.RemoteViews
import android.widget.TextView

import es.antonborri.home_widget.HomeWidgetPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.PluginRegistry
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

//import kotlin.time.Duration

//import androidx.compose.runtime.Composable
//import androidx.glance.text.Text
//import androidx.glance.GlanceId
//
//import androidx.glance.appwidget.GlanceAppWidget
//import androidx.glance.appwidget.GlanceAppWidgetReceiver
//import androidx.glance.appwidget.provideContent
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
    val includeSecond = intervalFormat.contains("s", ignoreCase = true)

    var resultString = ""
    var daysNum = interval.toDays()
    var tmp = interval

    if (includeDay && !includeHour && !includeMinute) {
        resultString += interval.toDays().toString()
    } else if (includeDay) {
        resultString += interval.toDays().toString() + "d "
        tmp = tmp.minusDays(tmp.toDays())
    }

    if (includeHour) {
        resultString += tmp.toHours().toString() + "h "
        tmp = tmp.minusHours(tmp.toHours())
    }

    if (includeMinute) {
        resultString += tmp.toMinutes().toString() + "m "
        tmp = tmp.minusMinutes(tmp.toMinutes())
    }

    if (includeSecond) {
//        resultString += interval.minusMinutes(interval.toMinutes()).toSeconds().toString() + "s "
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
    val standardIntervalFormatTiny = context.getString(R.string.standard_interval_format_tiny)
    val pendingIntent = PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java),
        PendingIntent.FLAG_IMMUTABLE)

    val wideViews = RemoteViews(context.packageName, R.layout.countdown_widget).apply {
        var dateString = widgetData.getString("countdown_date", null)
        val preferredTimeFormat = widgetData.getString("preferred_time_format", null).takeIf { it != null } ?: standardTimeFormat
        val preferredIntervalFormat = widgetData.getString("countdown_preferred_interval_format", null).takeIf { it != null } ?: standardIntervalFormat
        val date = LocalDateTime.parse(dateString, DateTimeFormatter.ofPattern(standardTimeFormat))
        dateString = formatLocalDateTime(date, preferredTimeFormat)

        val dateName = widgetData.getString("countdown_name", null)

        val dateNamePrefix = if (date.isBefore(LocalDateTime.now())) "Since" else "To"

        val interval = if (date.isBefore(LocalDateTime.now()))
            Duration.between(date, LocalDateTime.now()) else
            Duration.between(LocalDateTime.now(), date)

        val intervalString = parseIntervalFormat(interval, preferredIntervalFormat)

        setOnClickPendingIntent(R.id.widget_box, pendingIntent)

        setTextViewText(R.id.date_as_string, dateString)
        setTextViewText(R.id.date_name, dateName)
        setTextViewText(R.id.date_name_prefix, dateNamePrefix)
        setTextViewText(R.id.interval_string, intervalString)
    }

    val narrowViews = RemoteViews(context.packageName, R.layout.countdown_widget_narrow).apply {
        var dateString = widgetData.getString("countdown_date", null)
        val preferredTimeFormat = widgetData.getString("preferred_time_format", null).takeIf { it != null } ?: standardTimeFormat
        val preferredIntervalFormat = widgetData.getString("preferred_interval_format", null).takeIf { it != null } ?: standardIntervalFormat
        val date = LocalDateTime.parse(dateString, DateTimeFormatter.ofPattern(standardTimeFormat))
        dateString = formatLocalDateTime(date, preferredTimeFormat)

        val imagePath = widgetData.getString("bgimage", null)
        val bitmap = BitmapFactory.decodeFile(imagePath)

        val dateName = widgetData.getString("countdown_name", null)

        val dateNamePrefix = if (date.isBefore(LocalDateTime.now())) "Since" else "To"

        val interval = if (date.isBefore(LocalDateTime.now()))
            Duration.between(date, LocalDateTime.now()) else
            Duration.between(LocalDateTime.now(), date)

        val intervalString = parseIntervalFormat(interval, preferredIntervalFormat)

        setOnClickPendingIntent(R.id.widget_box, pendingIntent)

        setImageViewBitmap(R.id.calendar_background, bitmap)
        setTextViewText(R.id.date_as_string, "dateString")
        setTextViewText(R.id.date_name, dateName)
        setTextViewText(R.id.date_name_prefix, dateNamePrefix)
        setTextViewText(R.id.interval_string, intervalString)
    }

    val tinyViews = RemoteViews(context.packageName, R.layout.countdown_widget_tiny).apply {
        val dateString = widgetData.getString("countdown_date", null)
        val preferredIntervalFormat = widgetData.getString("preferred_interval_format", null).takeIf { it != null } ?: standardIntervalFormatTiny
        val date = LocalDateTime.parse(dateString, DateTimeFormatter.ofPattern(standardTimeFormat))
        val intervalStringColor = widgetData.getString("countdown_interval_color", null)

        val interval = if (date.isBefore(LocalDateTime.now()))
            Duration.between(date, LocalDateTime.now()) else
            Duration.between(LocalDateTime.now(), date)

        val textColorString = intervalStringColor.takeIf { it != null } ?:
            if (date.isBefore(LocalDateTime.now())) "#CC0000" else "#009500"

        val intervalString = parseIntervalFormat(interval, preferredIntervalFormat)

        setOnClickPendingIntent(R.id.widget_box, pendingIntent)

        setInt(R.id.interval_string, "setTextColor", Color.parseColor(textColorString))
        setTextViewText(R.id.interval_string, intervalString)
    }

    var remoteView: RemoteViews

    if (android.os.Build.VERSION.SDK_INT >= 31) {

        val viewMapping: Map<SizeF, RemoteViews> = mapOf(
            SizeF(215f, 100f) to wideViews,
            SizeF(150f, 100f) to tinyViews,
        )
        remoteView = RemoteViews(viewMapping)

    } else {
        remoteView = wideViews
    }

    appWidgetManager.updateAppWidget(appWidgetId, remoteView)
}

//
//class CountdownWidgetReceiver : GlanceAppWidgetReceiver() {
//    override val glanceAppWidget: GlanceAppWidget = CountdownWidget()
//}
//
//class CountdownWidget : GlanceAppWidget() {
//
//    override suspend fun provideGlance(context: Context, id: GlanceId) {
//        provideContent {
//            CountdownContent()
//        }
//    }
//
//    @Composable
//    private fun CountdownContent() {
//        Text("5")
//    }
//}

