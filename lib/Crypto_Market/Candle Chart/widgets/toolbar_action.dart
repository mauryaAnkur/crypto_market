import 'package:flutter/material.dart';

/// Top toolbar button widget.
class ToolBarAction extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final double width;
  final Color? color;

  const ToolBarAction({
    Key? key,
    required this.child,
    required this.onPressed,
    this.width = 30,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: RawMaterialButton(
        elevation: 0,
        fillColor: color,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade600, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(child: child),
      ),
    );
  }
}
