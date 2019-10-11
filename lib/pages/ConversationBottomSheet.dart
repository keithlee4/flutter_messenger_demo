import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/config/Palette.dart';
import 'package:messenger/widgets/NavigationPillWidget.dart';
import 'package:messenger/config/Styles.dart';
import 'package:messenger/widgets/ChatRowWidget.dart';

class ConversationBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConversationBottomSheetState();
}
class _ConversationBottomSheetState extends State<ConversationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            NavigationPillWidget(),
            Center(child: Text('Messages', style: Styles.textHeading,)),
            SizedBox(
              height: 20,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 75, right: 20),
                child: Divider(
                  color: Palette.accentColor,
                ),
              ),
              itemBuilder: (context, index) {
                return ChatRowWidget();
              },
            )
          ],
        ),
      )
    );
  }
}