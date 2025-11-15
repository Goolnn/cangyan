import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final RouteObserver<PageRoute> _observer;

  final Widget child;

  const Body({
    super.key,

    required this.child,

    required RouteObserver<PageRoute> observer,
  }) : _observer = observer;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return child;
          },
        );
      },

      observers: [_observer],
    );
  }
}
