import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messenger/config/Palette.dart';
import 'package:messenger/widgets/ChatAppBar.dart';
import 'package:messenger/widgets/ChatListWidget.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage();
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: ChatAppBar()),
        Expanded(
          flex: 11,
          child: Container(
            color: Palette.chatBackgroundColor,
            child: ChatListWidget(),
          ),
        )
      ],
    );
  }
}
