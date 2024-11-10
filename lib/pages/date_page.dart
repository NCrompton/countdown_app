import 'package:flutter/material.dart';

import '../components/date_component.dart';

class DatePage extends StatelessWidget {
  const DatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Center(child: DateText()),
      ],
    );
  }
}
