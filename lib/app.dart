import 'package:calendar/screens/home_page.dart';
import 'package:flutter/cupertino.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Calendar',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
        brightness: Brightness.light,
      ),
      home: HomePage(title: 'Countdown Calendar'),
      debugShowCheckedModeBanner: false,
    );
  }
}
