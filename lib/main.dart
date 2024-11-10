import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar/pages/date_page.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> initState() async {
  final pref = await SharedPreferences.getInstance();
  final String? targetDateString = pref.getString(targetDateConfig);

  if (targetDateString != null) {
    DateTime targetDate = DateTime.parse(targetDateString);
    DateNotifier().setTargetDate(targetDate);
  } 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Countdown Calendar'),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void handleFloatButtonOnPress() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const DatePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: handleFloatButtonOnPress,
        tooltip: 'Press',
        child: const Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

