package com.example.calendar

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.R
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.Button
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.ActionParameters
import androidx.glance.action.actionParametersOf
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import kotlinx.coroutines.flow.MutableStateFlow

class BudgetWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = BudgetWidget()
}

class BudgetWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            CreateUI(context, currentState())
        }
    }

    @Composable
    fun CreateUI(context: Context, currentState: HomeWidgetGlanceState) {
        val data = currentState.preferences

        val state = remember { mutableStateOf(0) }

        Column(
            modifier = GlanceModifier.fillMaxSize(),
            verticalAlignment = Alignment.Top,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalAlignment = Alignment.CenterVertically,
                modifier = GlanceModifier.fillMaxSize().padding(16.dp)
            ) {
                // Display
                Box(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .height(60.dp)
                        .background(androidx.glance.unit.ColorProvider(Color.LightGray))
                        .padding(8.dp)
                ) {
                    Text(
                        text = state.value.toString(),
                        style = TextStyle(
                            color = ColorProvider(day = Color.Black, night = Color.White),
//                            fontSize = androidx.glance.unit.Sp(24)
                        ),
                        modifier = GlanceModifier.fillMaxWidth()
                    )
                }

                // Calculator Buttons
                val buttons = listOf(
                    listOf("7", "8", "9", "/"),
                    listOf("4", "5", "6", "*"),
                    listOf("1", "2", "3", "-"),
                    listOf("C", "0", "=", "+")
                )

                buttons.forEach { row ->
                    Row(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = GlanceModifier.fillMaxWidth()
                    ) {
                        row.forEach { label ->
                            NewButton(label, state)
                        }
                    }
                }
            }
            Row(horizontalAlignment = Alignment.CenterHorizontally) {
                Button(
                    text = "Home",
                    onClick = actionStartActivity<MainActivity> ()
                )
                Button(
                    text = "Work",
                    onClick = actionStartActivity<MainActivity>()
                )
            }
        }
    }
}

class NavigationActivity : AppCompatActivity() {
    companion object {
        val KEY_DESTINATION: String = "destination"
    }
}

private val destinationKey = ActionParameters.Key<String>(
    NavigationActivity.KEY_DESTINATION
)

@Composable
fun NewButton(label: String, state: MutableState<Int>) {
    Box(
        contentAlignment = Alignment.Center,
        modifier = GlanceModifier
            .size(60.dp)
            .background(androidx.glance.unit.ColorProvider(Color.LightGray))
            .clickable(actionRunCallback<CalculatorAction>(actionParametersOf(destinationKey to label)))
    ) {
        Text(
            text = label,
            style = TextStyle(
                color = androidx.glance.unit.ColorProvider(Color.White),
                fontSize = 18.sp,
            )
        )
    }
}

class CalculatorAction : ActionCallback {
    private val destinationKey = ActionParameters.Key<String>(
        NavigationActivity.KEY_DESTINATION
    )

    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val destination: String = parameters[destinationKey] ?: return
        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("Mason://BudgetWidgetCallback"))
        backgroundIntent.send()
    }
}

