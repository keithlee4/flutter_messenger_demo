import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/blocs/authentication/bloc.dart';
import 'package:messenger/blocs/repository/AuthenticationRepository.dart';
import 'package:messenger/blocs/repository/StorageRepository.dart';
import 'package:messenger/blocs/repository/UserDataRepository.dart';
import 'package:messenger/config/Palette.dart';
import 'package:messenger/pages/ContactListPage.dart';
import 'package:messenger/pages/ConversationPageSlide.dart';
import 'package:messenger/pages/Register/RegisterPage.dart';

void main() {
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        userDataRepository: userDataRepository,
        storageRepository: storageRepository
      )
      ..add(AppLaunched()),
      child: Messenger()
    )
  );
}

class Messenger extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Palette.primaryColor
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return ContactListPage();
          // if (state is UnAuthenticated) {
          //   return RegisterPage();
          // }else if (state is ProfileUpdated) {
          //   return ConversationPageSlide();
          // } else {
          //   return RegisterPage();
          // }
        },
      ),
    );
  }
}
