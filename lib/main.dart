import 'package:calendar/screens/date_calculation_page.dart';
import 'package:calendar/utils/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar/pages/front_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


// @pragma("vm:entry-point")
// void callbackDispatcher() async {
  
// }

// @pragma("vm:entry-point")
// void interactiveCallback(Uri? data) {

// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void init() {
    print("initing page");
  }

  @override
  Widget build(BuildContext context) {
    init();
    return const CupertinoApp(
      title: 'Calendar',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
        brightness: Brightness.light,
      ),
      home: MyHomePage(title: 'Countdown Calendar'),
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
  void _showDateSelection() async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => const DateCalculationPage(),
      ),
    );
    
    if (result != null) {
      final selectedDate = result['date'] as DateTime;
      final selectedNumber = result['number'] as int;
      // Handle the selection
      // You can update your state or provider here
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: Stack(
        children: [
          // Add safe area to prevent content from going under the navigation bar
          SafeArea(
            child: DatePage(),
          ),
          // Position the button at the bottom right
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: _showDateSelection,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  CupertinoIcons.calendar_badge_plus,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

