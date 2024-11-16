import 'package:flutter/material.dart';

class NotePad extends StatefulWidget {
  final bool show;

  final Widget child;

  const NotePad({
    super.key,
    this.show = false,
    required this.child,
  });

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  final key = GlobalKey();

  Size? size;

  @override
  void initState() {
    super.initState();

    updateSize();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        updateSize();

        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Stack(
          key: key,
          children: [
            widget.child,
            if (size != null)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: widget.show ? 0.0 : -size!.height,
                child: SizedBox(
                  width: size!.width,
                  height: size!.height,
                  child: const Card(
                    elevation: 8.0,
                    child: Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.2,
                          child: Divider(
                            thickness: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void updateSize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final renderBox = key.currentContext!.findRenderObject() as RenderBox;

      final size = Size(
        renderBox.size.width,
        renderBox.size.height / 3.0,
      );

      if (this.size == size) {
        return;
      }

      setState(() {
        this.size = size;
      });
    });
  }
}
