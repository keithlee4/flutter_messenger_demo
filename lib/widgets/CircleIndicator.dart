import 'package:flutter/material.dart';
import 'package:messenger/config/Palette.dart';

class CircleIndicator extends StatefulWidget {
  final bool isActive;
  CircleIndicator(this.isActive);
  @override
  State<StatefulWidget> createState() => _CircleIndicatorState();
}

class _CircleIndicatorState extends State<CircleIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: widget.isActive ? 12 : 8,
      width: widget.isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: widget.isActive ? Palette.primaryColor : Palette.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}