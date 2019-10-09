import 'package:flutter/widgets.dart';
import 'package:messenger/pages/ConversationPage.dart';

class ConversationPageList extends StatefulWidget {
  @override
  _CovnersationPageListState createState() => _CovnersationPageListState();
}

class _CovnersationPageListState extends State<ConversationPageList> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        ConversationPage(),
        ConversationPage(),
        ConversationPage(),
      ],
    );
  }
}
