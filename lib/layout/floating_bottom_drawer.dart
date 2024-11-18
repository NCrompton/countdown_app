import 'package:calendar/controllers/view_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingBottomDrawer extends StatefulWidget {
  final double heightPortion;
  final Widget child;
  final VisibilityController visibilityController;

  FloatingBottomDrawer({
    super.key,
    required this.child, 
    this.heightPortion=0.8,
    required this.visibilityController,
  });

  @override
  State<FloatingBottomDrawer> createState() => FloatingBottomDrawerState();
  
}

class FloatingBottomDrawerState extends State<FloatingBottomDrawer> {

  @override
  Widget build(BuildContext context) {
    final panelHeight = MediaQuery.of(context).size.height * widget.heightPortion;

    return ListenableBuilder(
      listenable: widget.visibilityController,
      builder: (BuildContext context, Widget? child){
        return AnimatedPositioned(
          left: 0,
          right: 0,
          bottom: widget.visibilityController.visible ? 0 : -panelHeight,
          height: panelHeight,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {  // Dragging down
                widget.visibilityController.setVisibility(false);
                print(widget.visibilityController.visible);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Panel content
                  Expanded(
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  
}