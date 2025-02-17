import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:messenger/config/Palette.dart';

class ChatItemWidget extends StatelessWidget {
  final int index;
  ChatItemWidget(this.index);

  @override
  Widget build(BuildContext context) {
    if (index % 2 == 0) {
      //This is the sent message. We'll later use data from firebase instead of index
      //the message is sent or received.
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    'This is a sent message',
                    style: TextStyle(color: Palette.selfMessageColor)
                  ),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Palette.selfMessageBackgroundColor,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(
                    DateFormat('dd MMM kk:mm')
                      .format(DateTime.fromMicrosecondsSinceEpoch(1565888474278)),
                    style: TextStyle(
                      color: Palette.greyColor,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                )
              ],
            )
          ],
        ),
      );
    }else {
      //This is a received message
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    'This is a received message',
                    style: TextStyle(color: Palette.otherMessageColor),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Palette.otherMessageBackgroundColor,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],          
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(1565888474278)),
                style: TextStyle(
                  color: Palette.greyColor,
                  fontSize: 12.0,
                  fontStyle: FontStyle.normal,
                ),
              ),
              margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}