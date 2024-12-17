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
          bottom: widget.visibilityController.visible ? 0 : -height,
          height: height,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: Column(
            children: [
              /* Dismiss View Mask, Prevent Tap Event Transfer to Child */
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.visibilityController.setVisibility(false);
                  }
                ),
              ),

              /* Bottom Drawer */
              TapRegion(
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.visibilityController.setVisibility(false);
                },
                child: Container(
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
                            if (_tapDownPos.dy + details.delta.dy < 0 ) return;
                            /* prevent view go below screen */
                            if (_tapDownPos.dy + details.delta.dy > panelHeight) return;
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

abstract class FloatingBottomDrawerWrapper extends StatelessWidget{
  final Widget Function(BuildContext, VisibilityController) builder;
  final Widget Function(void Function() dismiss) drawerChild;
  final VisibilityController? controller;
  final double heightPortion;

  const FloatingBottomDrawerWrapper({
    super.key,
    required this.builder,  
    required this.drawerChild,
    this.controller,
    this.heightPortion=0.8,
  });
}

class FloatingBottomDrawerPage extends FloatingBottomDrawerWrapper{
  const FloatingBottomDrawerPage({
    super.key, 
    required super.builder,  
    required super.drawerChild,
    super.controller,
    super.heightPortion,
  });


  @override
  Widget build(BuildContext context) {
  final visibilityController = controller ?? VisibilityController(false);

    return SafeArea(
        child: Stack(
          children: [
            builder(context, visibilityController),
            FloatingBottomDrawer(
              visibilityController: visibilityController,
              heightPortion: heightPortion,
              child: drawerChild(() => visibilityController.setVisibility(false)), 
            ),
          ]
        )
    );
  }
}

class FloatingBottomDrawerScaffold extends FloatingBottomDrawerWrapper {
  final String title;

  const FloatingBottomDrawerScaffold({
    super.key, 
    required this.title,
    required super.builder,
    required super.drawerChild,
    super.controller,
    super.heightPortion,
  });

  @override
  Widget build(BuildContext context) {
  final visibilityController = controller ?? VisibilityController(false);

    return ListenableBuilder(listenable: visibilityController, builder: (BuildContext context, Widget? child){ 
      return GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: CupertinoPageScaffold(
                      resizeToAvoidBottomInset: false,
                      navigationBar: CupertinoNavigationBar(
                        middle: Text(title),
                        trailing: IconButton(
                          onPressed: visibilityController.toggleVisibility, 
                          icon: Icon(visibilityController.visible ? Icons.close : Icons.add)
                        ),
                      ),
                      child: FloatingBottomDrawerPage(
                        heightPortion: heightPortion,
                        controller: visibilityController,
                        drawerChild: drawerChild,
                        builder: builder,
                      ),
                    )
                  );
                }
    );
  }
}