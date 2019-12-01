import 'package:flutter/material.dart';
import 'package:messenger/config/Palette.dart';

class QuickScrollBar extends StatefulWidget {
  final List nameList;
  final ScrollController scrollController;

  QuickScrollBar({@required this.nameList, @required this.scrollController});
  @override
  State<StatefulWidget> createState() => _QuickScrollBarState(nameList, scrollController);
}

class _QuickScrollBarState extends State<QuickScrollBar> {
  double offsetContainer = 0.0;
  var scrollBarText;
  var scrollBarTextPrev;
  var scrollBarHeight;
  var contactRowSize = 45.0;
  final scrollBarMarginRigth = 50.0;
  var scrollBarContainerHeight;
  var scrollBarPosSelected = 0;
  var scrollBarHeightDiff = 0.0;
  var screenHeight = 0.0;

  ScrollController scrollController;
  String scrollBarBubbleText = '';
  bool scrollBarBubbleVisibility = false;

  List nameList;

  _QuickScrollBarState(this.nameList, this.scrollController);

  List alphabetList = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  Widget _getAlphabetItem(int index) {
    return Expanded(
      child: Container(
        width: 40,
        height: 20,
        alignment: Alignment.center,
        child: Text(alphabetList[index],
            style: (index == scrollBarPosSelected) 
              ? TextStyle(fontSize: 16, fontWeight: FontWeight.w700) 
              : TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
      ),
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {
    offsetContainer = details.globalPosition.dy - scrollBarHeightDiff;
    setState(() {
      scrollBarBubbleVisibility = true;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      scrollBarBubbleVisibility = false;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      scrollBarBubbleVisibility = true;
      if ((offsetContainer + details.delta.dy) >= 0 &&
          (offsetContainer + details.delta.dy) <=
              scrollBarContainerHeight - scrollBarHeight) {
        offsetContainer += details.delta.dy;
        scrollBarPosSelected = ((offsetContainer / scrollBarHeight) % alphabetList.length).round();
        scrollBarText = alphabetList[scrollBarPosSelected];
        if (scrollBarText != scrollBarTextPrev) {
          for (var i = 0; i < nameList.length; i++) {
            if (scrollBarText.toString() == (nameList[i].toString().toUpperCase()[0])) {
              scrollController.jumpTo(i * contactRowSize);
              break;
            }
          }
          scrollBarTextPrev = scrollBarText;
        }
      }
    });
  }

  Widget getBubble() {
    if (!scrollBarBubbleVisibility) {
      return Container();
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Palette.accentColor,
        borderRadius: BorderRadius.all(const Radius.circular(30.0))
      ),
      width: 30,
      height: 30,
      child: Center(
        child: Text(
          "${scrollBarText ?? alphabetList.first}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        scrollBarHeightDiff = screenHeight - constraints.biggest.height;
        scrollBarHeight = constraints.biggest.height / alphabetList.length;
        scrollBarContainerHeight = constraints.biggest.height;
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onVerticalDragStart: _onVerticalDragStart,
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(alphabetList.length,
                          (index) => _getAlphabetItem(index))),
                ),
              ),
            ),
            Positioned(
              right: scrollBarMarginRigth,
              top: offsetContainer,
              child: getBubble(),
            )
          ],
        );
      },
    );
  }
}
