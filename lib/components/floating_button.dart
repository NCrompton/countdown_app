import 'package:calendar/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingMenuItem {
  final String? title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const FloatingMenuItem({
    required this.icon,
    required this.onTap,
    this.title,
    Color? color,
  }):
    color = color ?? CupertinoColors.activeBlue;
}

class FloatingMenu extends StatefulWidget {
  final List<FloatingMenuItem> menuItems;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double mainButtonSize;
  final EdgeInsets padding;

  const FloatingMenu({
    super.key,
    required this.menuItems,
    this.icon = CupertinoIcons.add,
    this.backgroundColor = CupertinoColors.activeBlue,
    this.iconColor = CupertinoColors.white,
    this.mainButtonSize = 60,
    this.padding = const EdgeInsets.all(16),
  });

  double get menuItemSize => mainButtonSize * 0.8;
  (double right, double bottom) get menuItemPos => (
    padding.right + (mainButtonSize - menuItemSize) / 2,
    padding.bottom + (mainButtonSize - menuItemSize) / 2
  );

  @override
  State<FloatingMenu> createState() => _FloatingMenuState();
}

class _FloatingMenuState extends State<FloatingMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _maskAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _maskAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,  // Maximum opacity of the mask
    ).animate(_expandAnimation)
    ..addStatusListener((s) {
      if (s.isDismissed && _isOpen) {
        _isOpen = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = true;
      if (_controller.isDismissed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
  
  Widget _buildMenuItem(FloatingMenuItem item, int i) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Positioned(
          right: widget.menuItemPos.$1,
          bottom: widget.menuItemPos.$2 
            + MediaQuery.of(context).padding.bottom 
            + _expandAnimation.value * widget.mainButtonSize * 1.2 
            + _expandAnimation.value * widget.mainButtonSize * (i),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label
              if (item.title != null) 
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axis: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.2),
                            offset: const Offset(0, 0),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Text(
                        item.title!,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
          
              const SizedBox(width: 8),
          
              // Button
              GestureDetector(
                onTap: () {
                  _toggleMenu();
                  item.onTap();
                },
                child: Container(
                  width: widget.menuItemSize,
                  height: widget.menuItemSize,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(widget.menuItemSize / 2),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.2),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color.isLightColor() ? Colors.black : Colors.white,
                    size: widget.menuItemSize / 2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark overlay mask
        AnimatedBuilder(
          animation: _maskAnimation,
          builder: (context, child) => Visibility(
            visible: _isOpen,
            child: GestureDetector(
              onTap: _toggleMenu,  // Close menu when tapping outside
              child: Container(
                color: Colors.black.withOpacity(_maskAnimation.value),
              ),
            ),
          ),
        ),

        ...widget.menuItems.mapIndexed(_buildMenuItem).toList(),
        
        // Floating button and menu
        Positioned(
          right: widget.padding.right,
          bottom: widget.padding.bottom + MediaQuery.of(context).padding.bottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 8),
              // Main Button
              GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  width: widget.mainButtonSize,
                  height: widget.mainButtonSize,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.mainButtonSize / 2),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedIcon(
                      color: Colors.white,
                      progress: _controller,
                      icon: AnimatedIcons.menu_close
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 