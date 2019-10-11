import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/config/Palette.dart';
import 'package:messenger/config/Assets.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar();
  final double height = 100;
  @override
  Widget build(BuildContext context) {
    var textHeading = TextStyle(color: Palette.primaryTextColor, fontSize: 20);
    var textStyle = TextStyle(color: Palette.secondaryTextColor);

    double width = MediaQuery.of(context).size.width; //calculate the screen width
    return Material(
      child: Container(
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.black,
            blurRadius: 5.0
          )
        ]),
        child: Container(
          color: Palette.primaryBackgroundColor,
          child: Row(
            children: <Widget>[
              Expanded( //we are deviding the app bar into 7:3 ratio. 7 for content 3 for display picture
                flex: 7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 70 - (width * .06),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Icon(
                                Icons.attach_file,
                                color: Palette.secondaryColor
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Keith Lee', style: textHeading),
                                  // Text('@keithlee4', style: textStyle)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //Second row containing the buttons for media
                    Container(
                      height: 23,
                      padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Photos',
                            style: textStyle,
                          ),
                          VerticalDivider(
                            width: 30,
                            color: Palette.primaryTextColor,
                          ),
                          Text(
                            'Videos',
                            style: textStyle,
                          ),
                          VerticalDivider(
                            width: 30,
                            color: Palette.primaryTextColor,
                          ),
                          Text(
                            'Files',
                            style: textStyle
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Center(
                    child: CircleAvatar(
                      radius: (80 - (width * .06)) / 2,
                      backgroundImage: Image.asset(
                        Assets.user
                      ).image,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}