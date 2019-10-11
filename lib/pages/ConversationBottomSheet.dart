import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/widgets/NavigationPillWidget.dart';

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
            Center(child: Text('Messages', style: Styles.textHeading,),)
          ],
        ),
      )
    );
  }
}