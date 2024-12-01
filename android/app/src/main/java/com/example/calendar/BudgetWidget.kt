package com.example.calendar

import android.R
import android.content.Context
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.min
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalSize
import androidx.glance.action.ActionParameters
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class BudgetWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = BudgetWidget()
}

/* Parameter Name of a State Variable in App Widget */
class ParameterNameActivity : AppCompatActivity() {
    companion object {
        const val KEY_VALUE: String = "VALUE"
    }
}

class BudgetWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            CreateUI(context)
        }
    }

    private val valueKey = ActionParameters.Key<MutableState<String>>(
        ParameterNameActivity.KEY_VALUE
    )

    private fun getPadForSize(size: DpSize) :  Pair<Dp, Dp> {
        val vPad = when {
            size.height < 100.dp -> 2.dp
            size.height < 150.dp -> 4.dp
            size.height < 200.dp -> 6.dp
            else -> 8.dp
        }
        val hPad = when {
            size.width < 100.dp -> 2.dp
            size.width < 150.dp -> 4.dp
            size.width < 200.dp -> 6.dp
            else -> 8.dp
        }

        return Pair(vPad, hPad)
    }

    private fun getFontSize(size: DpSize) : TextUnit {
        return when {
            min(size.height/2, size.width) < 200.dp -> 18.sp
            else -> 24.sp
        }
    }

    // Calculator Buttons
    private val buttons = listOf(
        listOf("7", "8", "9"),
        listOf("4", "5", "6"),
        listOf("1", "2", "3"),
        listOf("C", "0", ".")
    )

    override val sizeMode = SizeMode.Exact

    @Composable
    fun CreateUI(context: Context) {
        val size = LocalSize.current
        val state = remember { mutableStateOf("") }
        val fontSize = getFontSize(size)
        val (vPad, hPad) = getPadForSize(size)

        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalAlignment = Alignment.CenterVertically,
            modifier = GlanceModifier.fillMaxSize().padding(0.dp)
        ) {
            // Display
            Box(
                contentAlignment = Alignment.Center,
                modifier = GlanceModifier
                    .size(size.width, size.height/5)
                    .background(androidx.glance.unit.ColorProvider(Color.LightGray))
                    .padding(vertical = vPad, horizontal = hPad)
            ) {
                Text(
                    text = state.value,
                    style = TextStyle(
                        color = ColorProvider(day = Color.Black, night = Color.White),
                        fontSize = fontSize
                    ),
                    modifier = GlanceModifier.fillMaxWidth()
                )
                Box(
                    contentAlignment = Alignment.CenterEnd,
                    modifier = GlanceModifier
                        .fillMaxSize()
                ) {
                    Box(
                        contentAlignment = Alignment.Center,
                        modifier = GlanceModifier
                            .padding(vertical = vPad, horizontal = hPad)
                            .fillMaxHeight()
                            .cornerRadius(8.dp)
                            .background(ColorProvider(day = Color.White, night = Color.Black))
                            .clickable(
//                                actionRunCallback<CalculatorAction>(
//                                    actionParametersOf(
//                                        valueKey to state
//                                    )
//                                )
                            ) {
                                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("mason://BudgetWidgetCallback?value=${state.value}"))
                                backgroundIntent.send()
                                state.value = ""
                            }
                    ) {
                        Image(provider = ImageProvider(R.drawable.ic_input_add), contentDescription = "")
                    }
                }
            }

            buttons.forEach { row ->
                Row(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = GlanceModifier.width(size.width)
                ) {
                    row.forEach { label ->
                        NumButton(label, state, fontSize)
                    }
                }
            }
        }

    }
}

@Composable
fun NumButton(label: String, state: MutableState<String>, fontSize: TextUnit) {
    val size = LocalSize.current

    Box(
        contentAlignment = Alignment.Center,
        modifier = GlanceModifier
            .size(size.width/3, size.height/5)
            .background(androidx.glance.unit.ColorProvider(Color.LightGray)).clickable {
                if (label == "C") {
                    state.value = ""
                }else {
                    state.value += label
                }
            }
    ) {
        Text(
            text = label,
            style = TextStyle(
                color = androidx.glance.unit.ColorProvider(Color.White),
                fontSize = fontSize,
            )
        )
    }
}

/* For reusable action */
class BudgetAction : ActionCallback {
    private val valueKey = ActionParameters.Key<MutableState<String>>(
        ParameterNameActivity.KEY_VALUE
    )

    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val destination: MutableState<String> = parameters[valueKey] ?: return
        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("Mason://BudgetWidgetCallback?value=${destination.value}"))
        backgroundIntent.send()
    }
}

