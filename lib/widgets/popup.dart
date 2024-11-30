import 'package:flutter/material.dart';

class PopupMenuItem<T> extends PopupMenuEntry<T> {
  final T? value;

  final bool enabled;

  final void Function()? onTap;

  final Widget child;

  @override
  final double height;

  const PopupMenuItem({
    super.key,
    this.value,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.onTap,
    required this.child,
  });

  @override
  bool represents(T? value) {
    return value == this.value;
  }

  @override
  State<StatefulWidget> createState() {
    return _PopupMenuItemState();
  }
}

class _PopupMenuItemState<T> extends State<PopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.enabled
          ? () {
              Navigator.pop<T>(context, widget.value);

              widget.onTap?.call();
            }
          : null,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.child,
      ),
    );
  }
}

class PopupMenuDivider extends PopupMenuEntry<Never> {
  @override
  final double height;

  const PopupMenuDivider({
    super.key,
    this.height = 8.0,
  });

  @override
  bool represents(void value) {
    return false;
  }

  @override
  State<StatefulWidget> createState() {
    return _PopupMenuDividerState();
  }
}

class _PopupMenuDividerState extends State<PopupMenuDivider> {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: widget.height,
    );
  }
}
