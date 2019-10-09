import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/pages/ConversationPageList.dart';

void main() => runApp(Messenger());

class Messenger extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Messenger',
      theme: CupertinoThemeData(
        primaryColor: Colors.blue
      ),
      home: ConversationPageList(),
    );
  }
}
