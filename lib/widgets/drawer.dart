import 'package:flutter/material.dart';

class Drawer extends StatefulWidget {
  final DrawerController? controller;

  final Widget drawer;
  final Widget child;

  const Drawer({
    super.key,
    this.controller,
    required this.drawer,
    required this.child,
  });

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  late final DrawerController controller;

  Curve get curve {
    switch (controller.open) {
      case true:
        return Curves.easeOutCubic;
      case false:
        return Curves.easeInCubic;
    }
  }

  @override
  void initState() {
    super.initState();

    controller = widget.controller ?? DrawerController();
    controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final drawerSize = Size(
          constraints.maxWidth,
          constraints.maxHeight / controller.factor,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            AnimatedPositioned(
              bottom: controller.open ? 0.0 : -drawerSize.height,
              duration: const Duration(milliseconds: 300),
              curve: curve,
              child: SizedBox(
                width: drawerSize.width,
                height: drawerSize.height,
                child: Card(
                  child: Column(
                    children: [
                      if (controller.draggable)
                        GestureDetector(
                          child: const SizedBox(
                            width: 96.0,
                            child: Divider(
                              thickness: 1.5,
                            ),
                          ),
                        ),
                      Expanded(
                        child: widget.drawer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    // return PopScope(
    //   canPop: !_controller.open,
    //   onPopInvokedWithResult: (didPop, result) {
    //     if (didPop) {
    //       return;
    //     }

    //     _controller.open = false;
    //   },
    //   child: NotificationListener<SizeChangedLayoutNotification>(
    //     onNotification: (notification) {
    //       updateSize();

    //       return true;
    //     },
    //     child: SizeChangedLayoutNotifier(
    //       child: Stack(
    //         key: key,
    //         children: [
    //           widget.child,
    //           if (size != null)
    //             AnimatedPositioned(
    //               curve: _curve,
    //               duration: dragging != null
    //                   ? const Duration()
    //                   : const Duration(milliseconds: 300),
    //               bottom: _controller.open
    //                   ? (dragging != null ? min(0.0, -dragging!) : 0.0)
    //                   : -size!.height,
    //               child: SizedBox(
    //                 width: size!.width,
    //                 height: size!.height,
    //                 child: Card(
    //                   elevation: 8.0,
    //                   child: Column(
    //                     children: [
    //                       GestureDetector(
    //                         behavior: HitTestBehavior.opaque,
    //                         onPanDown: (details) {
    //                           setState(() {
    //                             dragging = 0.0;
    //                           });
    //                         },
    //                         onPanUpdate: (details) {
    //                           setState(() {
    //                             dragging = details.localPosition.dy;
    //                           });
    //                         },
    //                         onPanEnd: (details) {
    //                           final v = details.velocity.pixelsPerSecond.dy;
    //                           final l = size!.height / 2.0;

    //                           if (v >= 1000.0 || dragging! >= l) {
    //                             _controller.open = false;
    //                           }

    //                           setState(() {
    //                             dragging = null;
    //                           });
    //                         },
    //                         child: const Center(
    //                           child: FractionallySizedBox(
    //                             widthFactor: 0.2,
    //                             child: Divider(
    //                               thickness: 1.5,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       Expanded(
    //                         child: widget.drawer,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // void updateSize() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     final renderBox = key.currentContext!.findRenderObject() as RenderBox;

  //     final size = Size(
  //       renderBox.size.width,
  //       renderBox.size.height / 3.0,
  //     );

  //     if (this.size == size) {
  //       return;
  //     }

  //     setState(() {
  //       this.size = size;
  //     });
  //   });
  // }
}

class DrawerController extends ChangeNotifier {
  bool _open = false;
  bool _draggable = true;

  double _factor = 3.0;

  bool get open => _open;
  bool get draggable => _draggable;
  double get factor => _factor;

  set open(bool value) {
    _open = value;

    notifyListeners();
  }

  set draggable(bool value) {
    _draggable = value;

    notifyListeners();
  }

  set factor(double value) {
    _factor = value;

    notifyListeners();
  }
}
