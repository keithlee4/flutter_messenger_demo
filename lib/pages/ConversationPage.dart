import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messenger/pages/ConversationBottomSheet.dart';
import 'package:messenger/widgets/ChatAppBar.dart';
import 'package:messenger/widgets/ChatListWidget.dart';
import 'package:messenger/widgets/InputWidget.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage();
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: ChatAppBar(),
        body: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              ChatListWidget(), 
              GestureDetector(
                child: InputWidget(),
                onPanUpdate: (details) {
                  if (details.delta.dy < 0) {
                    //swiping up
                    _scaffoldKey.currentState.showBottomSheet(
                      (BuildContext context) {
                        return ConversationBottomSheet();
                      }
                    );
                  }
                },
              )
            ],
          )]
        ),
      ),
    );
  }
}
