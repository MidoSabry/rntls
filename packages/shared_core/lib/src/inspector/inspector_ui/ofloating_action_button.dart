import 'package:flutter/material.dart';

class OFloatingActionButton extends StatefulWidget {
  final Widget child;

  const OFloatingActionButton({super.key, required this.child});

  @override
  State<OFloatingActionButton> createState() => _OFloatingActionButtonState();
}

class _OFloatingActionButtonState extends State<OFloatingActionButton> {
  double posX = 100;
  double posY = 100;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: posX,
      top: posY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            posX += details.delta.dx;
            posY += details.delta.dy;
          });
        },
        child: widget.child,
      ),
    );
  }
}