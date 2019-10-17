import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const <dynamic>[]]) : super();
}
//Dispatched by main.dart everytime the app start.
class AppLaunched extends AuthenticationEvent {
  @override
  List<Object> get props => null;
  
  @override
  String toString() => 'AppLaunched';
}

class ClickedGoogleLogin extends AuthenticationEvent {
  @override
  List<Object> get props => null;
  @override
  String toString() => 'ClickedGoogleLogin';
}

class LoggedIn extends AuthenticationEvent {
  final FirebaseUser user;
  LoggedIn(this.user);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'LoggedIn';
}

class PickedProfilePicture extends AuthenticationEvent {
  final File file;
  PickedProfilePicture(this.file);
  @override
  List<Object> get props => null;
  @override
  String toString() => 'PickerProfilePicture';
}

class SaveProfile extends AuthenticationEvent {
  final File profileImage;
  final int age;
  final String username;
  SaveProfile(this.profileImage, this.age, this.username);
  @override
  List<Object> get props => null;
  @override
  String toString() => 'SaveProfile';
}

class ClickedLogout extends AuthenticationEvent {
  @override
  List<Object> get props => null;
  @override
  String toString() => 'ClickedLogout';
}

