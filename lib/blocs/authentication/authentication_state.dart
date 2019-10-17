import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/blocs/model/User.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const<dynamic>[]]) : super();
}
  
class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => null;
  @override
  String toString() => 'Uninitialized';
}

class AuthInProgress extends AuthenticationState {
  @override
  List<Object> get props => null;
  @override
  String toString() => 'AuthInProgress';
}

class Authenticated extends AuthenticationState {
  final FirebaseUser user;
  Authenticated(this.user);
  @override
  List<Object> get props => null;
  @override
  String toString() => 'Authenticated';
}

class PreFillData extends AuthenticationState {
  final User user;
  PreFillData(this.user);
  @override
  List<Object> get props => null;
  @override
  String toString() => 'PreFillData';
}

class UnAuthenticated extends AuthenticationState {
  @override
  List<Object> get props => null;
  @override
  String toString() => 'UnAuthenticated';
}

class ReceivedProfilePicture extends AuthenticationState {
  final File file;
  ReceivedProfilePicture(this.file);

  @override
  List<Object> get props => null;
  @override
  String toString() => 'ReceivedProfilePicture';
}

class ProfileUpdateInProgress extends AuthenticationState {
  @override
  List<Object> get props => null;
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class ProfileUpdated extends AuthenticationState {
  @override
  List<Object> get props => null;
  @override
  String toString() => 'ProfileUpdated';
}
