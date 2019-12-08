import 'package:equatable/equatable.dart';
import 'package:messenger/blocs/model/Contact.dart';
import 'package:messenger/utils/Exceptions.dart';

abstract class ContactsState extends Equatable {
  ContactsState([List props = const <dynamic>[]]) : super();
  @override
  List<Object> get props => [];
}

class InitialContactsState extends ContactsState {
  @override
  String toString() => 'InitalContactsState';
}

class FetchingContactsState extends ContactsState {
  @override
  String toString() => 'FetchingContactsState';
}

class FetchedContactsState extends ContactsState {
  final List<Contact> contacts;
  FetchedContactsState(this.contacts);
  @override
  String toString() => 'FetchedContactsState';
}

class ShowAddContactState extends ContactsState {
  @override
  String toString() => 'ShowAddContactState';
}

class AddContactProgressState extends ContactsState {
  @override
  String toString() => 'AddContactProgressState';
}

class AddContactSuccessState extends ContactsState {
  @override
  String toString() => 'AddContactSuccessState';
}

class AddContactFailedState extends ContactsState {
  final MessioException exception;
  AddContactFailedState(this.exception);
  @override
  String toString() => 'AddContactFailedState';
}

class ClickedContactState extends ContactsState {
  @override
  String toString() => 'ClickedContactState';
}

class ErrorState extends ContactsState {
  final MessioException exception;
  ErrorState(this.exception);
  @override
  String toString() => 'ErrorState';
}
