import 'package:flutter/material.dart';
import 'package:messenger/config/Palette.dart';

class GradientFab extends StatelessWidget {
  final Animation<double> animation;
  final TickerProvider vsync;

  const GradientFab({Key key, @required this.animation, @required this.vsync})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(microseconds: 1000),
      curve: Curves.linear,
      vsync: vsync,
      child: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomRight,
                    colors: [
                      Palette.gradientStartColor,
                      Palette.gradientEndColor
                    ]
                  )
                ),
            child: Icon(Icons.add),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
