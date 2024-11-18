import 'package:flutter/cupertino.dart';

/// ListTilePageRoute creates a custom page transition animation that expands
/// from a list tile to a full screen page.
///
/// The animation starts from the exact position and dimensions of the tapped
/// list tile (specified by [originRect]) and smoothly expands to fill the 
/// entire screen. During the transition:
/// 
/// - The content expands from the list tile size to full screen
/// - The background fades in with a semi-transparent color
/// - The animation uses an ease-in-out curve for natural movement
/// - The transition can be dismissed by tapping the background
///
/// Example usage:
/// ```dart
/// Navigator.of(context).push(
///   ListTilePageRoute(
///     originRect: tileRect,  // Rectangle representing the list tile position
///     child: DestinationPage(),
///   ),
/// );
/// ```
class ListTilePageRoute extends PageRoute {
  final Widget child;
  final Rect originRect;

  ListTilePageRoute({
    required this.child,
    required this.originRect,
  });

  @override
  Color? get barrierColor => CupertinoColors.systemBackground.withOpacity(0.5);

  // Whether tapping the background dismisses the route
  @override
  bool get barrierDismissible => true;

  // Label for accessibility
  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  // Whether to maintain the state of the route when it's inactive
  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Stack(
      children: [
        FadeTransition(
          opacity: animation,
          child: Container(color: barrierColor),
        ),
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final progress = Curves.easeInOut.transform(animation.value);
            final height = MediaQuery.of(context).size.height;
            final width = MediaQuery.of(context).size.width;
            
            return Positioned(
              left: originRect.left * (1 - progress),
              top: originRect.top * (1 - progress),
              width: originRect.width + (width - originRect.width) * progress,
              height: originRect.height + (height - originRect.height) * progress,
              child: child!,
            );
          },
          child: child,
        ),
      ],
    );
  }
} 