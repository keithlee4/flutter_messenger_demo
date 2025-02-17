import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/blocs/authentication/bloc.dart';
import 'package:messenger/config/Assets.dart';
import 'package:messenger/config/Palette.dart';
import 'package:messenger/config/Styles.dart';
import 'package:messenger/config/Transitions.dart';
import 'package:messenger/pages/ConversationPageSlide.dart';
import 'package:messenger/widgets/CircleIndicator.dart';
import 'package:numberpicker/numberpicker.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;

  File profileImageFile;
  ImageProvider profileImage;
  int age = 18;
  final TextEditingController usernameController = TextEditingController();

  var isKeyboardOpen = false;

  PageController pageController = PageController();

  //Fields related to animation of the gredient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  //Fields related to animation the layout and pushing widgets up when the focus
  //is on the username field.
  AnimationController usernameFieldAnimationController;
  Animation profilePicHeightAnimation, usernameAnimation, ageAnimation;
  FocusNode usernameFocusNode = FocusNode();

  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    initApp();
    super.initState();
  }

  void initApp() async {
    WidgetsBinding.instance.addObserver(this);
    usernameFieldAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    profilePicHeightAnimation = Tween<double>(begin: 100.0, end: 0.0)
        .animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    usernameAnimation =
        Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    ageAnimation =
        Tween(begin: 80.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });

    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        usernameFieldAnimationController.forward();
      } else {
        usernameFieldAnimationController.reverse();
      }
    });

    pageController.addListener(() {
      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });

    authenticationBloc = BlocProvider.of(context);
    authenticationBloc.listen((state) {
      if (state is Authenticated) {
        updatePageState(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding:
            false, //avoids the bottom overflow warning when keyboard is shown
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              buildHome(),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthInProgress ||
                      state is ProfileUpdateInProgress) {
                    return buildCircularProgressBarWidget();
                  } else {
                    return SizedBox();
                  }
                },
              )
            ],
        )),
      ),
    );
  }

  Widget buildHome() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [Palette.gradientStartColor, Palette.gradientEndColor])),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 1500),
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (int page) => updatePageState(page),
              children: <Widget>[buildPageOne(), buildPageTwo()],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < 2; i++) CircleIndicator(i == currentPage),
              ],
            ),
          ),
          buildUpdateProfileButtonWidget()
        ],
      ),
    );
  }

  Widget buildUpdateProfileButtonWidget() {
    return AnimatedOpacity(
      opacity: currentPage == 1 ? 1.0 : 0.0, //shows only on page 1
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => authenticationBloc.add(
                  SaveProfile(profileImageFile, age, usernameController.text)),
              elevation: 0,
              backgroundColor: Palette.primaryColor,
              child: Icon(
                Icons.done,
                color: Palette.accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCircularProgressBarWidget() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [Palette.gradientStartColor, Palette.gradientEndColor])),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              buildHeaderSectionWidget(),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Palette.primaryColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageOne() {
    return Column(
      children: <Widget>[buildHeaderSectionWidget(), buildGoogleButtonWidget()],
    );
  }

  Widget buildHeaderSectionWidget() {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 250),
          child: Image.asset(Assets.app_icon_fg, height: 100)),
      Container(
        margin: EdgeInsets.only(top: 30),
        child: Text(
          'Messenger Demo',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      )
    ]);
  }

  Widget buildGoogleButtonWidget() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: ButtonTheme(
        height: 40,
        child: FlatButton.icon(
          onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
              .add(ClickedGoogleLogin()),
          color: Colors.transparent,
          icon: Image.asset(Assets.google_button, height: 25),
          label: Text('Sign In with Google',
              style: TextStyle(
                  color: Palette.primaryTextColorLight,
                  fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }

  Widget buildPageTwo() {
    return InkWell(onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
    }, child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        profileImage = Image.asset(Assets.user).image;
        if (state is PreFillData) {
          if (state.user.photoUrl != null) {
            profileImage = Image.network(state.user.photoUrl).image;
          }
          age = state.user.age != null ? state.user.age : 18;
        } else if (state is ReceivedProfilePicture) {
          profileImageFile = state.file;
          profileImage = Image.file(profileImageFile).image;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: profilePicHeightAnimation.value,
            ),
            buildProfilePictureWidget(),
            SizedBox(
              height: ageAnimation.value,
            ),
            Text('How old are you?', style: Styles.questionLight),
            buildAgePickerWidget(),
            SizedBox(
              height: usernameAnimation.value,
            ),
            Text('Choose a username', style: Styles.questionLight),
            buildUsernameWidget()
          ],
        );
      },
    ));
  }

  Widget buildUsernameWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 120,
      child: TextField(
        textAlign: TextAlign.center,
        style: Styles.subHeadingLight,
        focusNode: usernameFocusNode,
        decoration: InputDecoration(
            hintText: '@username',
            hintStyle: Styles.hintTextLight,
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Palette.primaryColor, width: 0.1)),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Palette.primaryColor, width: 0.1))),
      ),
    );
  }

  Widget buildAgePickerWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NumberPicker.horizontal(
          initialValue: age,
          minValue: 15,
          maxValue: 100,
          highlightSelectedValue: true,
          onChanged: (num value) {
            setState(() {
              age = value;
            });
          },
        ),
        Text('Years', style: Styles.textLight)
      ],
    );
  }

  Widget buildProfilePictureWidget() {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.camera, color: Colors.white, size: 15),
            Text('Set Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10))
          ],
        ),
        backgroundImage: profileImage,
        radius: 60,
      ),
    );
  }

  updatePageState(int index) {
    if (index == 1)
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);

    setState(() {
      currentPage = index;
    });
  }

  Future pickImage() async {
    profileImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    authenticationBloc.add(PickedProfilePicture(profileImageFile));
  }

  Future<bool> onWillPop() async {
    if (currentPage == 1) {
      pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    usernameFieldAnimationController.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  /// This routine is invoked when the window metrics have changed
  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (isKeyboardOpen) onKeyboardChanged(false);

      isKeyboardOpen = false;
    } else {
      isKeyboardOpen = true;
      onKeyboardChanged(true);
    }
  }

  onKeyboardChanged(bool isVisible) {
    if (!isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
      usernameFieldAnimationController.reverse();
    }
  }

  navigateToHome() {
    Navigator.push(context, SlideLeftRoute(page: ConversationPageSlide()));
  }
}
