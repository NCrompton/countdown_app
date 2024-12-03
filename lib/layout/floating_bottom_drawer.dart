import 'package:calendar/controllers/view_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingBottomDrawer extends StatefulWidget {
  final double heightPortion;
  final Widget child;
  final VisibilityController visibilityController;

  const FloatingBottomDrawer({
    super.key,
    required this.child, 
    this.heightPortion=0.8,
    required this.visibilityController,
  });

  @override
  State<FloatingBottomDrawer> createState() => FloatingBottomDrawerState();
  
}

class FloatingBottomDrawerState extends State<FloatingBottomDrawer> {
  Offset _tapDownPos = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final panelHeight = height * widget.heightPortion;

    return ListenableBuilder(
      listenable: widget.visibilityController,
      builder: (BuildContext context, Widget? child){
        return AnimatedPositioned(
          left: 0,
          right: 0,
          bottom: widget.visibilityController.visible ? 0 : -panelHeight,
          height: height,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: Column(
            children: [
              /* Dismiss View Mask */
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.visibilityController.setVisibility(false);
                  },
                ),
              ),
              Container(
                height: panelHeight - _tapDownPos.dy,
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

                /* Main Content */
                child: Column(
                  children: [
                    /* Handle bar */
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          /* prevent view go higher than original */
                          if (_tapDownPos.dy <= 0 && details.delta.dy < 0 ) return;
                          _tapDownPos += details.delta;
                        });
                      },
                      onVerticalDragEnd: (details) {
                        setState(() {
                          /* more natrual experience */
                          if (_tapDownPos.dy > panelHeight * 0.9) {
                            widget.visibilityController.setVisibility(false);
                          }
                          _tapDownPos = Offset.zero;
                        });
                        if (details.primaryVelocity! > 0) widget.visibilityController.setVisibility(false);
                      },
                      child: _buildDragToDismissSection(),
                    ),
                    /* Panel content */
                    Expanded(
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ]
          )
        );
      }
    );
  }
  
  Widget _buildDragToDismissSection() {
    return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
  }
}

class FloatingBottomDrawerPage extends StatefulWidget {
  final Widget Function(BuildContext, VisibilityController) build;
  final Widget drawerChild;
  final double heightPortion;

  const FloatingBottomDrawerPage({
    super.key, 
    required this.build,  
    required this.drawerChild,
    this.heightPortion=0.8,
  });

  @override
  State<FloatingBottomDrawerPage> createState() => _FloatingBottomDrawerPageState();
}

class _FloatingBottomDrawerPageState extends State<FloatingBottomDrawerPage> {

  final VisibilityController _visibilityController = VisibilityController(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _visibilityController.setVisibility(false),
              child: widget.build(context, _visibilityController),
            ),
            FloatingBottomDrawer(
              visibilityController: _visibilityController,
              heightPortion: widget.heightPortion,
              child: widget.drawerChild, 
            ),
          ]
        )
    );
  }
}