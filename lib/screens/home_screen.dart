import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart'; // Add this import

import 'package:calendar/screens/countdown_screen.dart';
import 'package:calendar/data/countdown_data.dart';
import 'package:calendar/utils/const.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void updateHeadline(CountdownData newCountdown) {
  // Add from here
  // Save the headline data to the widget
  HomeWidget.saveWidgetData<String>(
      'countdown_date', newCountdown.date.toString());
  print("coutdown: " + newCountdown.date.toString());
  HomeWidget.saveWidgetData<int>('countdown_counter', newCountdown.counter);

  String diffTime =
      "${newCountdown.interval?.inDays} Days ${newCountdown.interval?.inHours.remainder(24)}:${newCountdown.interval?.inMinutes.remainder(60)}";
  HomeWidget.saveWidgetData<String>("countdown_interval", diffTime);
  HomeWidget.updateWidget(
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
} // To here.

List<CountdownData> getNewsStories() {
  return [
    CountdownData(date: DateTime(2024, 8, 16, 9), counter: 120),
    CountdownData(date: DateTime.now(), counter: 440)
  ];
}

class _MyHomePageState extends State<MyHomePage> {
  @override // Add from here
  void initState() {
    super.initState();

    HomeWidget.setAppGroupId(appGroupId);

    CountdownData countdownData =
        CountdownData(date: DateTime(2024, 8, 16, 9, 0), counter: 50);

    // Mock read in some data and update the headline
    // final newHeadline = countdownData;
    updateHeadline(countdownData);
  } // To here.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Top Stories'),
            centerTitle: false,
            titleTextStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        body: ListView.separated(
          separatorBuilder: (context, idx) {
            return const Divider();
          },
          itemCount: getNewsStories().length,
          itemBuilder: (context, idx) {
            final countdown = getNewsStories()[idx];
            return ListTile(
              key: Key('$idx ${countdown.hashCode}'),
              title: Text(countdown.date.toString()!),
              subtitle: Text(countdown.date.toString()!),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CountdownScreen(countdown: countdown);
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}
