import 'package:flutter/cupertino.dart';
import 'package:messenger/config/Palette.dart';

class NavigationPillWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Center(
              child: Wrap(
                children: <Widget>[
                  Container(
                    width: 50,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 5,
                    decoration: BoxDecoration(
                      color: Palette.accentColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}