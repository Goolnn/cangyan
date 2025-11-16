import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DropIcon extends StatefulWidget {
  final bool enable;

  final void Function(DropEventDetails)? onDragEntered;
  final void Function(DropEventDetails)? onDragExited;
  final void Function(DropDoneDetails)? onDragDone;
  final void Function(DropEventDetails)? onDragUpdated;

  final IconData icon;
  final double? size;
  final Color? color;

  final Widget? child;

  const DropIcon({
    super.key,

    this.enable = true,

    this.onDragEntered,
    this.onDragExited,
    this.onDragDone,
    this.onDragUpdated,

    required this.icon,
    this.size,
    this.color,

    this.child,
  });

  @override
  State<DropIcon> createState() => _DropIconState();
}

class _DropIconState extends State<DropIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) {
        _controller.forward();

        widget.onDragEntered?.call(details);
      },

      onDragExited: (details) {
        _controller.reverse();

        widget.onDragExited?.call(details);
      },

      onDragUpdated: widget.onDragUpdated,
      onDragDone: widget.onDragDone,

      child: Padding(
        padding: const EdgeInsets.all(32.0),

        child: AnimatedBuilder(
          animation: _animation,

          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,

              spacing: 8.0,

              children: [
                Icon(
                  widget.icon,
                  size: widget.size != null
                      ? widget.size! * _animation.value
                      : null,
                  color: widget.color,
                ),

                if (widget.child != null) widget.child!,
              ],
            );
          },
        ),
      ),
    );
  }
}
