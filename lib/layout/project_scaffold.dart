import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProjectScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const ProjectScaffold({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: Material(child: child),
    );
  }
}