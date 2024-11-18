import 'package:calendar/utils/custom_route.dart';
import 'package:flutter/cupertino.dart';

void openPageInner(BuildContext context, Widget child) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Rect originRect = box.localToGlobal(Offset.zero) & box.size;
    Navigator.of(context).push(
      ListTilePageRoute(
        originRect: originRect,
        child: child
      ),
    );
  }

  void openPageSide(BuildContext context, Widget child) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      )
    );
  }

  void openPageBottom(BuildContext context, Widget child) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset(0.0, 0.2);
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      )
    );
  }
