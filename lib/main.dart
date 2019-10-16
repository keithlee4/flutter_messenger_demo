import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/pages/ConversationPageSlide.dart';

void main() => runApp(Messenger());

class Messenger extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      home: ConversationPageSlide(),
    );
  }
}
